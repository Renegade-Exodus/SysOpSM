{$M 19456,0,655360}
PROGRAM SysOpSM;

USES
  Crt,
  DDPlus;

CONST
  MaxUsers = 500;

TYPE
  UserRecordType = RECORD
    Number: Integer;      {User Number}
    FirstName,            {First Name}
    LastName: STRING[30]; {last name}
    Hps,                  {Hit Points}
    MaxHps,               {Max Hit Points}
    Exp,                  {Experiece}
    Score,                {Score}
    Level: LongInt;       {Level}
  END;

  UserArrayType = ARRAY [1..MaxUsers] OF UserRecordType;

VAR
  UserArray: UserArrayType;
  User: UserRecordType;
  NewMAXHPS, NewEXP, NewLevel, NewSCORE, NewHPS, NumUsers: Integer;
  ch: Char;
  Z: Integer;

{***************************************************************}

FUNCTION IntToStr(L: LongInt): STRING;
VAR
  S: STRING;
BEGIN
  Str(L,S);
  IntToStr := S;
END;

{***************************************************************}

Procedure DoTheTitle;
begin
     PROGNAME:=('SysOp Smashin v0.01ä');
end;

{***************************************************************}

Procedure Pause;
begin
     swriteln('');
     set_foreground(9);
     swrite('[= ');
     set_foreground(15);
     swrite('ENTER');
     set_foreground(9);
     swrite(' =]');
     sread_char(ch);
     swriteln('');
     set_foreground(7);
end;

{***************************************************************}


Procedure DISPLAY;

Begin

swriteln('');
swriteln('');
swrite('User #       : ');
writeln(SOUTPUT,User.Number);
swrite('First Name   : ');
writeln(SOUTPUT,User.FirstName);
swrite('Last Name    : ');
writeln(SOUTPUT,User.LastName);
swrite('User HPS     : ');
writeln(SOUTPUT,User.Hps);
swrite('User MaxHPS  : ');
writeln(SOUTPUT,User.MaxHps);
swrite('User EXP     : ');
writeln(SOUTPUT,User.Exp);
swrite('User Score   : ');
writeln(SOUTPUT,User.Score);
swrite('User Level   : ');
writeln(SOUTPUT,User.Level);
swriteln('');
PAUSE;
END;

{*******************************************************************}


PROCEDURE Spin (C1, L1 : LongInt);

begin

sgoto_xy(C1,L1);set_foreground (8);swrite('|');sgoto_xy(C1,L1);delay(50);sgoto_xy(C1,L1);
set_foreground (7);swrite('/');sgoto_xy(C1,L1);delay(50);sgoto_xy(C1,L1);set_foreground (15);swrite('-');
sgoto_xy(C1,L1);delay(50);sgoto_xy(C1,L1);set_foreground (8);swrite('\');sgoto_xy(C1,L1);delay(50);
sgoto_xy(C1,L1);set_foreground (7);swrite('|');sgoto_xy(C1,L1);delay(50);sgoto_xy(C1,L1);
set_foreground (15);swrite('/');sgoto_xy(C1,L1);delay(50);sgoto_xy(C1,L1);set_foreground (8);swrite('-');
sgoto_xy(C1,L1);delay(50);sgoto_xy(C1,L1);set_foreground (7);swrite('\');sgoto_xy(C1,L1);delay(50);

end;

{***************************************************************}

PROCEDURE InitUserArray(VAR UserArray: UserArrayType);
VAR
  Counter: Integer;
BEGIN
  FOR Counter := 1 TO MaxUsers DO
    WITH UserArray[Counter] DO
    BEGIN
      Number := 0;
      FirstName := '';
      LastName := '';
      Hps   := 0;
      MaxHps:= 0;
      Exp   := 0;
      Score := 0;
      Level := 0;
    END;
END;

{***************************************************************}

PROCEDURE ReadInUserArray(VAR UserArray: UserArrayType; VAR NumUsers: Integer);
VAR
  UserFile: FILE OF UserRecordType;
  User: UserRecordType;
  Counter: Integer;
BEGIN
  (* Set all User Array Vars to Null *)
  InitUserArray(UserArray);
  (* Set total number of Users to 0 *)
  NumUsers := 0;
  (* Open file or create file *)
  Assign(UserFile,'SYSUSERS.DAT');
  {$I-} Reset(UserFile); {$I+}
  IF (IOResult <> 0) THEN
    ReWrite(UserFile);
  (* Fill the array with all active users up to Max allowed *)
  Counter := 1;
  WHILE (Counter <= FileSize(UserFile)) AND (Counter <= MaxUsers) DO
  BEGIN
    Seek(UserFile,(Counter - 1));
    Read(UserFile,User);
    IF (User.Number <> 0) THEN
    BEGIN
      UserArray[Counter] := User;
      (* Inc total user count *)
      Inc(NumUsers);
    END;
    Inc(Counter);
  END;
  Close(UserFile);
END;

{***************************************************************}

FUNCTION LoadUser(VAR UserArray: UserArrayType; VAR User: UserRecordType; VAR NumUsers: Integer): Boolean;
VAR
  UserFile: FILE OF UserRecordType;
  FirstName,
  LastName: STRING[30];
  Counter,
  Counter1: Integer;
BEGIN
  (* Get user information *)
  REPEAT

 FirstName:= User_first_name;
 LastName := User_last_name;

  UNTIL (FirstName <> '');

  (* Locate user in user array, if exists *)
  Counter1 := 0;
  Counter := 1;
  WHILE (Counter <= NumUsers) AND (Counter1 = 0) DO
  BEGIN
    WITH UserArray[Counter] DO
      IF (FirstName = User_First_Name) AND (LastName = User_Last_Name) THEN
        Counter1 := Counter;
    Inc(Counter);
  END;

  ClrScr;
  sWriteLn('');


  IF (Counter1 <> 0) THEN
  BEGIN
    (* If users exists, read in record and welcome them *)

    Assign(UserFile,'SYSUSERS.DAT');
    Reset(UserFile);
    Seek(UserFile,(Counter1 - 1));
    Read(UserFile,User);
    Close(UserFile);

    sWriteLn('Welcome Back!');
    sWriteln('');
    sWriteLn(User.FirstName+' '+User.LastName+' User #'+IntToStr(User.Number));

  END
  ELSE IF (NumUsers < MaxUsers) THEN
  BEGIN
    (* If user doesn't exist, add new record and welcome them *)

    Assign(UserFile,'SYSUSERS.DAT');
    Reset(UserFile);
    Counter1 := (FileSize(UserFile) + 1);
    WITH User DO
    BEGIN
      Number := Counter1;
      FirstName := User_First_Name;
      LastName := User_Last_Name;
      Hps := 25;
      MaxHps := 25;
      Exp := 1;
      Score := 100;
      Level := 1;
    END;
    Seek(UserFile,(Counter1 - 1));
    Write(UserFile,User);
    Close(UserFile);

    sWriteLn('You are a new user!!!   Welcome!');
    sWriteln('');
    sWriteLn(User.FirstName+' '+User.LastName+' User #'+IntToStr(User.Number));

    (* Update the user array due to the new user *)
    ReadInUserArray(UserArray,NumUsers);

  END
  ELSE
  BEGIN
    (* If new user and max users allowed, send message to user *)
    sWriteLn('This game already has the maximum users allowed');
    Counter1 := 0;
  END;

  sWriteLn('');
  Pause;

  LoadUser := (Counter1 <> 0);  (* Counter1 = 1 (User Found/Created), Counter1 = 0 (User Not Found/MaxUsers) *)

END;

{***************************************************************}

PROCEDURE EXITGAME;

VAR
  UserFile: FILE OF UserRecordType;
  FirstName,
  LastName: STRING[30];
  Counter,
  Counter1: Integer;

Begin
    Assign(UserFile,'SYSUSERS.DAT');
    Reset(UserFile);

    WITH User DO
    BEGIN
      Hps := Hps;
      MaxHps := MaxHps;
      Exp := Exp;
      Score := Score;
      Level := Level;
    END;


    Seek(UserFile,(Counter));
    Write(UserFile,User);
    Close(UserFile);
end;

{***************************************************************}


PROCEDURE Healer;


Begin

if User.Hps = User.MaxHps then begin
sclrscr;
swriteln('');
swriteln('');
swriteln('');
set_foreground(15);
swriteln('     You greedy little nerd, I am giving you to the count of three');
swriteln('       to get out of here or else you''ll be losing hitpoints!');
swriteln('');
swriteln('');
set_foreground(11);
swrite('                            ');delay(100);swrite('O');delay(10000);swrite('N');delay(10000);swrite('E');
delay(10000);swrite(' ');swrite('.');swrite('.');swrite('.');swrite(' ');swrite('T');delay(10000);
swrite('W');delay(10000);swrite('O');delay(10000);swrite(' ');swrite('.');swrite('.');swrite('.');
swrite(' ');swrite('T');delay(1000);delay(1000);swrite('H');delay(1000);swrite('R');delay(1000);
swrite('E');delay(1000);swrite('E');delay(1000);swrite('!');
swriteln(''); swriteln(''); swriteln('');
set_foreground(15);
swriteln('    With that, you quickly bust open the door and run for your life!');
write(User.MaxHps);
pause;
end
else begin
sclrscr;
swriteln('');
swriteln('');
swriteln('');
set_foreground(7);
swrite('                  You are now being healed . . . .  ');
set_foreground(15);
sgoto_xy(53,4); swrite('10%');delay(10500);
sgoto_xy(53,4); swrite('23%');delay(10500);
sgoto_xy(53,4); swrite('40%');delay(10500);
sgoto_xy(53,4); swrite('67%');delay(10500);
sgoto_xy(53,4); swrite('75%');delay(10500);
sgoto_xy(53,4); swrite('92%');delay(10500);
sgoto_xy(53,4); swrite('100%');
swriteln('');
User.Hps := User.MaxHps;
writeln(SOUTPUT,User.Hps);
swriteln('');
swriteln('');
set_foreground(7);
swriteln('');
swriteln('                             There, feel better?');
swriteln('');
swriteln('');
Pause;
end; end;

{***************************************************************}

PROCEDURE Intro;
begin
 sclrscr;
 swriteln('');
 swriteln('');
 set_foreground(15);
 swriteln('                       Welcome to SysOp Smashin v0.01ä');
 set_foreground(10);
 swriteln('                     (C) 1994 ... XXXX T.J. McMillen, Jr.');
 set_foreground(7);
 swriteln('');
 swriteln('                      Compiled on 01/16/XXXX:   20:45.19');
 swriteln('');
 set_foreground(8);
 swriteln('                      Compiled with:  Turbo Pascal v7.0');
 swriteln('                                      DDPLUS v7.1');
 swriteln('');
 swriteln('');
 set_foreground(7);
 swriteln('');
 set_foreground(7);
 swrite('                     Registered SysOp: '); set_foreground(15);
 swriteln('T.J. McMillen, Jr.');
 swriteln('');
 set_foreground(7);
 swrite('                      Registered BBS: '); set_foreground(15);
 swriteln('The Titantic BBS');swriteln('');
 Pause;
end;

{***************************************************************}

PROCEDURE PlayGame;

Var
ch, c, numhit: char;
I, Z, OP, HitPlay, HitRick, HitP, HitR, Level, Rick, Player1: longint;
S, SN, SNAME, SNUM: string[80];
Y : Integer;
Faces, Menu: String;
Morechk, Morecheck: Boolean;
w, x: text;


Label
     MainMenu, Sector1, Sector2, Sector3, Sector4, Instructions, Quit,
     DocReadPause, Heal, Rickey, FightRick, RickOption, RickMiss;

Begin
MainMenu:
If Z = 32767 then goto Quit;
sclrscr;
set_foreground (2);
numhit:='A';
displayfile('MAINMENU.ANS');
set_foreground(15);
sgoto_xy(56,13);
repeat
sread_char(ch);
ch:= UPCASE(ch);
until (ch = '1') or (ch = '2') or (ch = '3') or (ch = '4') or (ch = 'I')
or (ch = 'A') or (ch = 'H') or (ch = 'Q') or (ch = 'Y');
set_foreground (7);
sgoto_xy(56,13);
if (ch = '1') then begin
     swrite('SECTOR1.EXE');
     delay(50);
     sclrscr;
     set_foreground (15); set_background(1);
     swriteln('Running "C:\SYSOPSM\SECTOR1.EXE"                                                ');
     set_background(0); delay(60500);
     Goto Sector1; end;
if (ch = '2') then begin
     swrite('SECTOR2.EXE');
     delay(60050);
     Goto Sector2; end;
if (ch = '3') then begin
     swrite('SECTOR3.EXE');
     delay(60050);
     Goto Sector3; end;
if (ch = '4') or (ch = 'Y') then begin
     swrite('SECTOR4.EXE');
     delay(60050);
     Goto Sector4; end;
if (ch = 'I') then begin
     swrite('SYSINST.EXE');
     delay(60050);
     Goto Instructions; end;
if (ch = 'H') then begin
     swrite('HEAL.EXE');
     delay(60050);
     Healer; end;
if (ch = 'Q') then begin
     swrite('QUIT.EXE');
     delay(60050);
     Goto Quit; end;
Goto MainMenu;

Sector1:
begin
     sclrscr;
     set_foreground (15); set_background(1);
     swriteln('Running "C:\SYSOPSM\SECTOR1.EXE"                                                ');
     set_background(0); delay(60500);
     sclrscr;
     set_foreground (11);
     displayfile('SECTOR1.ANS');
REPEAT
     repeat
     SPIN(62,16);
     until skeypressed;

sgoto_xy(62,16);
swrite('');
sread_char(ch);
set_foreground(11);
ch:= UPCASE(ch);
if (ch = '1') or (ch = 'Q') or (ch = 'H') then begin
   sgoto_xy(28,19);
   set_foreground(7);
   swriteln('Processing Command ...');
   set_foreground(0);
   delay(150);
   sgoto_xy(28,19);
   swriteln('Processing Command ...');
   set_foreground(7);
   end
   else begin
       sgoto_xy(28,19);
       set_foreground(7);
       swriteln('Invalid Command ...');
       set_foreground(0);
       delay(150);
       sgoto_xy(28,19);
       swriteln('Invalid Command ...');
       set_foreground(7);
   end;
   until (ch = '1') or (ch = 'Q') or (ch = 'H');
swrite(ch);
delay(10);
if (ch = 'H') then Healer;
if (ch = '1') then goto Rickey;
if (ch = 'Q') then goto MainMenu;
goto Sector1;



Rickey:
begin;
Rick := 25;
sclrscr;
ch:='A';
Faces:='FACES.ANS'; SelectAnsi(ch,Faces);
Pause;

FightRick:
          sclrScr;
          swriteln('');
          set_foreground(10);
          swriteln('                 The Battle Begins -  Place Your Bets People.');
          swriteln('');
          swriteln('');
          set_foreground(2);
          swrite('Your Hitpoints : ');
          set_foreground(10);
          writeln(SOUTPUT,User.Hps);

if (User.Hps = 25) then numhit:= 'A' else if (User.Hps = 24) then numhit:= 'B';
if (User.Hps = 23) then numhit:= 'C' else if (User.Hps = 22) then numhit:= 'D';
if (User.Hps = 21) then numhit:= 'E' else if (User.Hps = 20) then numhit:= 'F';
if (User.Hps = 19) then numhit:= 'G' else if (User.Hps = 18) then numhit:= 'H';
if (User.Hps = 17) then numhit:= 'I' else if (User.Hps = 16) then numhit:= 'J';
if (User.Hps = 15) then numhit:= 'K' else if (User.Hps = 14) then numhit:= 'L';
if (User.Hps = 13) then numhit:= 'M' else if (User.Hps = 12) then numhit:= 'N';
if (User.Hps = 11) then numhit:= 'O' else if (User.Hps = 10) then numhit:= 'P';
if (User.Hps = 9) then numhit:= 'Q' else if (User.Hps = 8) then numhit:= 'R';
if (User.Hps = 7) then numhit:= 'S' else if (User.Hps = 6) then numhit:= 'T';
if (User.Hps = 5) then numhit:= 'U' else if (User.Hps = 4) then numhit:= 'V';
if (User.Hps = 3) then numhit:= 'W' else if (User.Hps = 2) then numhit:= 'X';
if (User.Hps = 1) then numhit:= 'Y';

set_foreground(8);
Menu:='LEVEL25.ANS'; SelectAnsi(numhit,Menu);
swriteln('');
set_foreground(2);
swrite('Rickey''s Hitpoints : ');
set_foreground(10);
writeln(SOUTPUT,Rick);

if (Rick = 25) then numhit:= 'A' else if (Rick = 24) then numhit:= 'B';
if (Rick = 23) then numhit:= 'C' else if (Rick = 22) then numhit:= 'D';
if (Rick = 21) then numhit:= 'E' else if (Rick = 20) then numhit:= 'F';
if (Rick = 19) then numhit:= 'G' else if (Rick = 18) then numhit:= 'H';
if (Rick = 17) then numhit:= 'I' else if (Rick = 16) then numhit:= 'J';
if (Rick = 15) then numhit:= 'K' else if (Rick = 14) then numhit:= 'L';
if (Rick = 13) then numhit:= 'M' else if (Rick = 12) then numhit:= 'N';
if (Rick = 11) then numhit:= 'O' else if (Rick = 10) then numhit:= 'P';
if (Rick = 9) then numhit:= 'Q' else if (Rick = 8) then numhit:= 'R';
if (Rick = 7) then numhit:= 'S' else if (Rick = 6) then numhit:= 'T';
if (Rick = 5) then numhit:= 'U' else if (Rick = 4) then numhit:= 'V';
if (Rick = 3) then numhit:= 'W' else if (Rick = 2) then numhit:= 'X';
if (Rick = 1) then numhit:= 'Y';

set_foreground(8);
Menu:='LEVEL25.ANS'; SelectAnsi(numhit,Menu);
swriteln('');
set_foreground(7);
displayfile ('OPTION.ANS');
sgoto_xy(19,17);
repeat
      sread_char(ch);
      set_foreground (11);
      ch:= UPCASE(ch);
until (ch = 'H') or (ch = 'K') or (ch = 'P') or (ch = 'J') or (ch = 'E') or (ch = 'S') or (ch = 'Y')
or (ch = 'T') or (ch = 'R') or (ch = 'B') or (ch = 'Q');

swrite(ch);
delay(60100);
Randomize;

If (ch = 'R') or (ch = 'Q') then goto Sector1;
If (ch = 'B') then begin swriteln(''); swriteln('');
                         swriteln('Not Implemented yet.');
                         pause; goto FightRick; end;
If (ch = 'S') then begin HitP := Random(2)+1;
                         HitR := Random(1)+1; end;
If (ch = 'P') then begin HitP := Random(2)+1;
                         HitR := Random(3)+1; end;
If (ch = 'H') then begin HitP := Random(2)+1;
                         HitR := Random(4)+0; end;
If (ch = 'J') then begin HitP := Random(2)+1;
                         HitR := Random(2)+1; end;
If (ch = 'T') then begin HitP := Random(1)+1;
                         HitR := Random(3)+0; end;
If (ch = 'Y') then begin HitP := Random(1)+1;
                         HitR := Random(2)+0; end;
If (ch = 'E') then begin HitP := Random(1)+1;
                         HitR := Random(1)+1; end;
If (ch = 'K') then begin HitP := Random(1)+1;
                         HitR := Random(3)+0; end;
goto RickOption;

RickOption:
HitPlay := User.HPS - HitP;
HitRick := Rick - HitR;
User.HPS := HitPlay;
Rick := HitRick;
swriteln(''); swriteln('');

If (HitR = 0) then begin
                   set_foreground (7); swrite('You');
                   set_foreground (27); swrite(' MISSED ');
                   set_foreground (7); swrite('Rickey Completely!!');
                   delay(60500); goto RickMiss; end;
If (ch = 'Y') then begin
                   set_foreground (7);
                   swrite ('You Scream an obsenity hurt Rickey''s feelings for ');
                   set_foreground (15); write(SOUTPUT,HitR);
                   set_foreground (7); swrite(' points of damage.');
                   delay(60500); end;
If (ch = 'H') then begin
                   set_foreground (7); swrite ('You Head Butt Rickey for ');
                   set_foreground (15); write(SOUTPUT,HitR);set_foreground (7);
                   swrite(' points of damage.'); delay(60500); end;
If (ch = 'E') then begin
                   set_foreground (7);
                   swrite ('You Elbow Rickey in the eye for '); set_foreground (15);
                   write(SOUTPUT,HitR); set_foreground (7);
                   swrite(' points of damage.'); delay(60500); end;
If (ch = 'K') then begin
                   set_foreground (7); swrite ('You Kick Rickey where it counts for ');
                   set_foreground (15); write(SOUTPUT,HitR); set_foreground (7);
                   swrite(' points of damage.'); delay(60500); end;
If (ch = 'T') then begin
                   set_foreground (7); swrite ('You Pick up a Rock and hurl it at Rickey for ');
                   set_foreground (15); write(SOUTPUT,HitR); set_foreground (7);
                   swrite(' points of damage.'); delay(60500); end;
If (ch = 'J') then begin
                   set_foreground (7); swrite ('You take a quick jab at Rickey''s face for ');
                   set_foreground (15); write(SOUTPUT,HitR); set_foreground (7);
                   swrite(' points of damage.'); delay(60500); end;
If (ch = 'P') then begin
                   set_foreground (7); swrite ('You Punch Rickey for ');
                   set_foreground (15); write(SOUTPUT,HitR); set_foreground (7);
                   swrite(' points of damage.'); delay(60500); end;
If (ch = 'S') then begin
                   set_foreground (7); swrite ('You Slapped Rickey for ');
                   set_foreground (15); write(SOUTPUT,HitR); set_foreground (7);
                   swrite(' points of damage.'); delay(60500); end;

RickMiss:
If Rick <=0 then begin
   sclrscr;
   swriteln('');
   swriteln('');
   set_foreground(15);
   swriteln('                       You have beaten SysOp Rickey!!');
   swriteln('');
   pause;
   goto Sector1; end;


   swriteln('');
   swriteln('');
   set_foreground (7);
   swrite ('Rickey hits you for ');
   set_foreground (15);
   write(SOUTPUT,HitP);
   set_foreground (7);
   swrite(' points of damage.');
   delay (60500);
   If User.HPS <=0 then goto Quit;
   goto FightRick;
end; end;




Sector2:
begin
     sclrscr;
     set_foreground(7);
     swriteln('Not Implemented Yet.');
     NewMAXHPS:=User.MaxHps+1;
     write('New NewMAXHPS ');
     writeln(NewMAXHPS);
     User.MaxHps := NewMAXHPS;
     write('New User.MaxHPS ');
     writeln(User.MaxHps);
     Pause;
     goto MainMenu;
end;

Sector3:
begin
     sclrscr;
     set_foreground(7);
     swriteln('Not Implemented Yet.');
     Pause;
     goto MainMenu;
end;

Sector4:
begin
     sclrscr;
     set_foreground(7);
     swriteln('Not Implemented Yet.');
     DISPLAY;
     goto MainMenu;
end;

Instructions:
begin
     sclrscr;
     set_foreground(7);
     assign (w, 'whats.new');
     reset(w);
    while not EOF(w) do begin
     For I:=1 to 20 do begin
     Readln(w, s);
     writeln(soutput, s);end;
     sgoto_xy(1,22);

     swriteln('');
     set_foreground(9);
     swrite('[');
     set_foreground(15);
     swrite('ENTER');
     set_foreground(9);
     swrite(']');
     swrite(' to Continue ');
     swrite('[');
     set_foreground(15);
     swrite('Q');
     set_foreground(9);
     swrite(']');
     swrite(' to Quit:  ');
     sread_char (ch);
     swriteln('');
     set_foreground(7);
If (ch='Q') or (ch='q') then goto MainMenu;

     sclrscr;
     sgoto_xy(1,22);
writeln('                                                                             ');
     sgoto_xy(1,1);
writeln('                                                                             ');
     end;
     goto MainMenu;



end;

Quit:
begin
     sclrscr;
     set_foreground (7);
     swriteln('');
     swriteln('');
     swrite('        Shutting Down Game Play ... ');
     set_foreground (15);
     swrite('QUIT.EXE');
     set_foreground (7);
     swrite(' or ');
     set_foreground (15);
     swrite('DEATH.EXE');
     set_foreground (7);
     swrite(' encountered.');
     swriteln('');
     swriteln('');
     Z:=32767;
     Pause;
end;
     ExitGame;
end;



BEGIN
  ClrScr;
  InitDoorDriver('SYSOPSM.CTL');
  DoTheTitle;
  ReadInUserArray(UserArray,NumUsers);
  IF LoadUser(UserArray,User,NumUsers) THEN
 If Graphics < 3 Then
  Begin
    sclrscr;
    swriteln('');swriteln('');
    swriteln('');swriteln('');
    set_foreground(15);
    swriteln('         The game requires ANSI color and graphics.  Your current');
    swriteln('         parameters do not qualify you for either.  To play this');
    swriteln('         game, go back to the BBS and select the ANSI graphics option,');
    swriteln('         usually found in the Personal Information Menu.');
    swriteln('');
    swriteln('                 ASK YOUR SYSOP IF YOU HAVE FURTHER PROBLEMS!');
    swriteln('');
    Pause;
    sclrscr;
    swriteln('');
    swriteln('');
    set_foreground(15);
    swriteln('Sending you back to the BBS.....');
    delay(750);
    Z:=32767;
end;
  Intro;
  Display;
  PlayGame;
  ExitGame;
  Display;
    (* Game code *)
END.

