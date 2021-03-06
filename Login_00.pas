unit Login_00;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls, Registry;

type
  // Conjunto de Tipos de Valores do Registro
  TKeyType = (ktString, ktBoolean, ktInteger, ktCurrency, ktDate, ktTime);

  TLogin00 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    login_usuario: TEdit;
    login_senha: TEdit;
    BTN_Ok: TButton;
    BTN_Cancelar: TLabel;
    Label4: TLabel;
    login_mensagem: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    login_medico: TComboBox;
    consultex_caminho: TEdit;
    Posicao_1: TEdit;
    Nro_Licenca: TLabel;
    Registro_ConsulTEX: TLabel;
    procedure BTN_CancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BTN_OkClick(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure login_usuarioKeyPress(Sender: TObject; var Key: Char);
    procedure login_senhaKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    // Fun��es
    function Verifica_Controle_Acessos():Boolean;
    function Ler_Registro_Windows(const Key: String; KeyType: TKeyType; DefValue: Variant): Variant;
    function Verifica_Registro():Boolean;

    // Procedures
    procedure Gravar_Registro_Windows(const Key: String; const Value: Variant; KeyType: TKeyType);
  public
    { Public declarations }
  end;

// Tipo de Vers�o
Const Tipo_Versao_Datatex: String = 'Full';
//Const Tipo_Versao_Datatex: String = 'Demo';

var
  Login00: TLogin00;
  Nro_Registro_Consultex: String;

implementation

uses Rotinas_Gerais, Conexao_BD, Conexao_00, Cons_02, Registra_ConsulTEX;

var
   Contador: Integer;

{$R *.dfm}

//***************
//*** Fun��es ***
//***************

function TLogin00.Verifica_Controle_Acessos():Boolean;

Var
    Resultado: Boolean;
    Posicao_Inicial, Posicao_Final, DT_Maxima: String;
    InstalledVersion, InstalledType, InstallPath, InstallPathTables, InstallAccessControl, Developer, InstallPermission: String;

Begin
    Resultado := False;

    InstalledVersion     := Ler_Registro_Windows('InstalledVersion',ktString,'');
    InstalledType        := Ler_Registro_Windows('InstalledType',ktString,'');
    InstallPath          := Ler_Registro_Windows('InstallPath',ktString,'');
    InstallPathTables    := Ler_Registro_Windows('InstallPathTables',ktString,'');
    InstallAccessControl := Ler_Registro_Windows('InstallAccessControl',ktString,'');
    Developer            := Ler_Registro_Windows('Developer',ktString,'');
    InstallPermission    := Ler_Registro_Windows('InstallPermission',ktString,'');

    If Tipo_Versao_Datatex = 'Full' Then
      begin
      If InstalledType = 'DM' Then
        begin
        Gravar_Registro_Windows('InstalledType','FL',ktString);
        Gravar_Registro_Windows('InstallAccessControl','#STXV#77#CTRL99#',ktString);
        Gravar_Registro_Windows('InstallPermission','D',ktString);

        InstalledVersion     := Ler_Registro_Windows('InstalledVersion',ktString,'');
        InstalledType        := Ler_Registro_Windows('InstalledType',ktString,'');
        InstallPath          := Ler_Registro_Windows('InstallPath',ktString,'');
        InstallPathTables    := Ler_Registro_Windows('InstallPathTables',ktString,'');
        InstallAccessControl := Ler_Registro_Windows('InstallAccessControl',ktString,'');
        Developer            := Ler_Registro_Windows('Developer',ktString,'');
        InstallPermission    := Ler_Registro_Windows('InstallPermission',ktString,'');
      End;
    End;

    If InstalledType = 'DM' Then
      Begin
      // Verifica os Registros de Demonstra��o
      Posicao_Inicial := Copy(InstallAccessControl,1,6);
      DT_Maxima       := Copy(InstallAccessControl,7,6);
      Posicao_Final   := Copy(InstallAccessControl,13,8);

      DT_Maxima := DT_Maxima[1]+DT_Maxima[2]+'/'+DT_Maxima[3]+DT_Maxima[4]+'/'+DT_Maxima[5]+DT_Maxima[6];

      If (Trim(Posicao_Inicial) = '#STXV#') And (Trim(Posicao_Final) = '#CTRL65#') Then
        Begin
        If (Date() >= StrToDate(DT_Maxima)) Then
          Begin
          Gravar_Registro_Windows('InstallPermission','T',ktString);
          Resultado := False;
          End
        Else
          Begin
          Resultado := True;
        End;
        End
      Else
        Begin
        Resultado := False;
      End;

      If InstallPermission = 'T' Then
         Begin
         Resultado := False;
      End;

      End
    Else If InstalledType = 'FL' Then
      Begin

      // Verifica os Registros de Vers�o Full
      If InstallAccessControl = '#STXV#77#CTRL99#' Then
        begin
        Resultado := True;
      End;
      End
    Else
      Begin

      // Grava os Registros de Vers�o

      Gravar_Registro_Windows('InstalledVersion','9.0',ktString);

      If Tipo_Versao_Datatex = 'Demo' Then
        Begin
        DT_Maxima := DateToStr(Date() + 30);
        DT_Maxima := DT_Maxima[1]+DT_Maxima[2]+DT_Maxima[4]+DT_Maxima[5]+DT_Maxima[7]+DT_Maxima[8];

        Gravar_Registro_Windows('InstalledType','DM',ktString);
        Gravar_Registro_Windows('InstallAccessControl','#STXV#'+Trim(DT_Maxima)+'#CTRL65#',ktString);
        End
      Else
        Begin
        Gravar_Registro_Windows('InstalledType','FL',ktString);
        Gravar_Registro_Windows('InstallAccessControl','#STXV#77#CTRL99#',ktString);
      End;

      Gravar_Registro_Windows('InstallPath','C:\ConsulTEX',ktString);
      Gravar_Registro_Windows('InstallPathTables','C:\ConsulTEX\Tabelas',ktString);
      Gravar_Registro_Windows('Developer','Datatex Inform�tica e Servi�os Ltda',ktString);
      Gravar_Registro_Windows('InstallPermission','D',ktString);

      // Verifica os Registros da Vers�o
      InstalledVersion     := Ler_Registro_Windows('InstalledVersion',ktString,'');
      InstalledType        := Ler_Registro_Windows('InstalledType',ktString,'');
      InstallPath          := Ler_Registro_Windows('InstallPath',ktString,'');
      InstallPathTables    := Ler_Registro_Windows('InstallPathTables',ktString,'');
      InstallAccessControl := Ler_Registro_Windows('InstallAccessControl',ktString,'');
      Developer            := Ler_Registro_Windows('Developer',ktString,'');
      InstallPermission    := Ler_Registro_Windows('InstallPermission',ktString,'');

      If InstalledType = 'DM' Then
        Begin

        // Verifica os Registros de Demonstra��o

        Posicao_Inicial := Copy(InstallAccessControl,1,6);
        DT_Maxima       := Copy(InstallAccessControl,7,6);
        Posicao_Final   := Copy(InstallAccessControl,13,8);

        DT_Maxima := DT_Maxima[1]+DT_Maxima[2]+'/'+DT_Maxima[3]+DT_Maxima[4]+'/'+DT_Maxima[5]+DT_Maxima[6];

        If (Trim(Posicao_Inicial) = '#STXV#') And (Trim(Posicao_Final) = '#CTRL65#') Then
          begin

          If (Date() >= StrToDate(DT_Maxima)) Then
             Begin
             Gravar_Registro_Windows('InstallPermission','T',ktString);
             Resultado := False;
             End
          Else
             Begin
             Resultado := True;
          End;

          end
        Else
          begin
          Resultado := False;
        end;

        If InstallPermission = 'T' Then
           Begin
           Resultado := False;
        End;

        end
      Else If InstalledType = 'FL' Then
        Begin

        // Verifica os Registros de Vers�o Full

        If InstallAccessControl = '#STXV#77#CTRL99#' Then
          begin
          Resultado := True;
        end;
      End;
    End;
    Verifica_Controle_Acessos := Resultado;
end;

Function TLogin00.Ler_Registro_Windows(const Key: String; KeyType: TKeyType; DefValue: Variant): Variant;

var
  r: TRegistry;

begin
  // cria o objeto TRegistry
  r := TRegistry.Create;
  // conecta ao root diferente do padr�o
  r.RootKey := HKEY_LOCAL_MACHINE;
  try
    // abre a chave (no root selecionado)
    // o segundo par�metro True, indica que se a chave n�o existir,
    // a opera��o de abertura poder� cri�-la.
    r.OpenKey('Software\Datatex\ConsulTEX', True);
    Result := DefValue;
    // testa se existe o valor que se deseja ler.
    // note que, para verificar a exist�ncia de chaves, utilizados KeyExists([chave])
    // e para verificar a exist�ncia de um conjunto de chaves de uma chave,
    // utilizamos ValueExists([valor])
    if r.ValueExists(Key) then
      case KeyType of
        // l� o valor da chave em formato String
        ktString: Result := r.ReadString(Key);
        // l� o valor da chave em formato Boolean
        ktBoolean: Result := r.ReadBool(Key);
        // l� o valor da chave em formato Integer
        ktInteger: Result := r.ReadInteger(Key);
        // l� o valor da chave em formato Currency (moeda)
        ktCurrency: Result := r.ReadCurrency(Key);
        // l� o valor da chave em formato TDateTime (data)
        ktDate: Result := r.ReadDate(Key);
        // l� o valor da chave em formato TDateTime (hora)
        ktTime: Result := r.ReadTime(Key);
      end;
  finally
    // destroy o objeto criado
    r.Free;
  end;

end;

function TLogin00.Verifica_Registro():Boolean;

var
   Nro_HD: String;
   Posicao: Array[0..10] of String;
   Posicao_Nro: Array[0..10] of Real;
   Ind: Integer;

   Str_Posicao, Letra_1, Letra_2, Letra_3, Calculo_1, Calculo_2, Calculo_3, Licenca: String;

   Retorno: Boolean;

   Linha_Arq: String;

begin
     Retorno := False;

     If Trim(Posicao_1.Text) = '' Then
        Begin
        Nro_HD := Numero_HD('C');
        Nro_HD := Trim(UpperCase(Nro_HD));

        //*** Registro ***

        For Ind := 1 To Length(Nro_HD) Do
            Begin
            If Nro_HD[Ind] = 'A' Then
               Begin
               Posicao[(Ind - 1)] := '01';
               End
            Else If Nro_HD[Ind] = 'B' Then
               Begin
               Posicao[(Ind - 1)] := '02';
               End
            Else If Nro_HD[Ind] = 'C' Then
               Begin
               Posicao[(Ind - 1)] := '03';
               End
            Else If Nro_HD[Ind] = 'D' Then
               Begin
               Posicao[(Ind - 1)] := '04';
               End
            Else If Nro_HD[Ind] = 'E' Then
               Begin
               Posicao[(Ind - 1)] := '05';
               End
            Else If Nro_HD[Ind] = 'F' Then
               Begin
               Posicao[(Ind - 1)] := '06';
               End
            Else If Nro_HD[Ind] = 'G' Then
               Begin
               Posicao[(Ind - 1)] := '07';
               End
            Else If Nro_HD[Ind] = 'H' Then
               Begin
               Posicao[(Ind - 1)] := '08';
               End
            Else If Nro_HD[Ind] = 'I' Then
               Begin
               Posicao[(Ind - 1)] := '09';
               End
            Else If Nro_HD[Ind] = 'J' Then
               Begin
               Posicao[(Ind - 1)] := '10';
               End
            Else If Nro_HD[Ind] = 'K' Then
               Begin
               Posicao[(Ind - 1)] := '11';
               End
            Else If Nro_HD[Ind] = 'L' Then
               Begin
               Posicao[(Ind - 1)] := '12';
               End
            Else If Nro_HD[Ind] = 'M' Then
               Begin
               Posicao[(Ind - 1)] := '13';
               End
            Else If Nro_HD[Ind] = 'N' Then
               Begin
               Posicao[(Ind - 1)] := '14';
               End
            Else If Nro_HD[Ind] = 'O' Then
               Begin
               Posicao[(Ind - 1)] := '15';
               End
            Else If Nro_HD[Ind] = 'P' Then
               Begin
               Posicao[(Ind - 1)] := '16';
               End
            Else If Nro_HD[Ind] = 'Q' Then
               Begin
               Posicao[(Ind - 1)] := '17';
               End
            Else If Nro_HD[Ind] = 'R' Then
               Begin
               Posicao[(Ind - 1)] := '18';
               End
            Else If Nro_HD[Ind] = 'S' Then
               Begin
               Posicao[(Ind - 1)] := '19';
               End
            Else If Nro_HD[Ind] = 'T' Then
               Begin
               Posicao[(Ind - 1)] := '20';
               End
            Else If Nro_HD[Ind] = 'U' Then
               Begin
               Posicao[(Ind - 1)] := '21';
               End
            Else If Nro_HD[Ind] = 'V' Then
               Begin
               Posicao[(Ind - 1)] := '22';
               End
            Else If Nro_HD[Ind] = 'W' Then
               Begin
               Posicao[(Ind - 1)] := '23';
               End
            Else If Nro_HD[Ind] = 'X' Then
               Begin
               Posicao[(Ind - 1)] := '24';
               End
            Else If Nro_HD[Ind] = 'Y' Then
               Begin
               Posicao[(Ind - 1)] := '25';
               End
            Else If Nro_HD[Ind] = 'Z' Then
               Begin
               Posicao[(Ind - 1)] := '26';
               End
            Else If Nro_HD[Ind] = '0' Then
               Begin
               Posicao[(Ind - 1)] := '00';
               End
            Else If Nro_HD[Ind] = '1' Then
               Begin
               Posicao[(Ind - 1)] := '01';
               End
            Else If Nro_HD[Ind] = '2' Then
               Begin
               Posicao[(Ind - 1)] := '02';
               End
            Else If Nro_HD[Ind] = '3' Then
               Begin
               Posicao[(Ind - 1)] := '03';
               End
            Else If Nro_HD[Ind] = '4' Then
               Begin
               Posicao[(Ind - 1)] := '04';
               End
            Else If Nro_HD[Ind] = '5' Then
               Begin
               Posicao[(Ind - 1)] := '05';
               End
            Else If Nro_HD[Ind] = '6' Then
               Begin
               Posicao[(Ind - 1)] := '06';
               End
            Else If Nro_HD[Ind] = '7' Then
               Begin
               Posicao[(Ind - 1)] := '07';
               End
            Else If Nro_HD[Ind] = '8' Then
               Begin
               Posicao[(Ind - 1)] := '08';
               End
            Else If Nro_HD[Ind] = '9' Then
               Begin
               Posicao[(Ind - 1)] := '09';
            End;
        End;

        //*** Troca e Multiplica��o de Posi��es ***

        Posicao[0] := IntToStr(StrToInt(Posicao[0]) * 3);
        Posicao[4] := IntToStr(StrToInt(Posicao[4]) * 3);
        Posicao[1] := IntToStr(StrToInt(Posicao[1]) * 3);
        Posicao[5] := IntToStr(StrToInt(Posicao[5]) * 3);
        Posicao[2] := IntToStr(StrToInt(Posicao[2]) * 3);
        Posicao[6] := IntToStr(StrToInt(Posicao[6]) * 3);
        Posicao[3] := IntToStr(StrToInt(Posicao[3]) * 3);
        Posicao[7] := IntToStr(StrToInt(Posicao[7]) * 3);

        If Length(Trim(Posicao[0])) <= 1 Then
           Begin
           Posicao[0] := '0'+Trim(Posicao[0]);
        End;

        If Length(Trim(Posicao[1])) <= 1 Then
           Begin
           Posicao[1] := '0'+Trim(Posicao[1]);
        End;

        If Length(Trim(Posicao[2])) <= 1 Then
           Begin
           Posicao[2] := '0'+Trim(Posicao[2]);
        End;

        If Length(Trim(Posicao[3])) <= 1 Then
           Begin
           Posicao[3] := '0'+Trim(Posicao[3]);
        End;

        If Length(Trim(Posicao[4])) <= 1 Then
           Begin
           Posicao[4] := '0'+Trim(Posicao[4]);
        End;

        If Length(Trim(Posicao[5])) <= 1 Then
           Begin
           Posicao[5] := '0'+Trim(Posicao[5]);
        End;

        If Length(Trim(Posicao[6])) <= 1 Then
           Begin
           Posicao[6] := '0'+Trim(Posicao[6]);
        End;

        If Length(Trim(Posicao[7])) <= 1 Then
           Begin
           Posicao[7] := '0'+Trim(Posicao[7]);
        End;

        //*** Obtem a 1a. Letra ***

        If Posicao[5]  = '01' Then
           Begin
           Letra_1 := 'A';
           End
        Else If Posicao[5]  = '02' Then
           Begin
           Letra_1 := 'B';
           End
        Else If Posicao[5]  = '03' Then
           Begin
           Letra_1 := 'C';
           End
        Else If Posicao[5]  = '04' Then
           Begin
           Letra_1 := 'D';
           End
        Else If Posicao[5]  = '05' Then
           Begin
           Letra_1 := 'E';
           End
        Else If Posicao[5]  = '06' Then
           Begin
           Letra_1 := 'F';
           End
        Else If Posicao[5]  = '07' Then
           Begin
           Letra_1 := 'G';
           End
        Else If Posicao[5]  = '08' Then
           Begin
           Letra_1 := 'H';
           End
        Else If Posicao[5]  = '09' Then
           Begin
           Letra_1 := 'I';
           End
        Else If Posicao[5]  = '10' Then
           Begin
           Letra_1 := 'J';
           End
        Else If Posicao[5]  = '11' Then
           Begin
           Letra_1 := 'K';
           End
        Else If Posicao[5]  = '12' Then
           Begin
           Letra_1 := 'L';
           End
        Else If Posicao[5]  = '13' Then
           Begin
           Letra_1 := 'M';
           End
        Else If Posicao[5]  = '14' Then
           Begin
           Letra_1 := 'N';
           End
        Else If Posicao[5]  = '15' Then
           Begin
           Letra_1 := 'O';
           End
        Else If Posicao[5]  = '16' Then
           Begin
           Letra_1 := 'P';
           End
        Else If Posicao[5]  = '17' Then
           Begin
           Letra_1 := 'Q';
           End
        Else If Posicao[5]  = '18' Then
           Begin
           Letra_1 := 'R';
           End
        Else If Posicao[5]  = '19' Then
           Begin
           Letra_1 := 'S';
           End
        Else If Posicao[5]  = '20' Then
           Begin
           Letra_1 := 'T';
           End
        Else If Posicao[5]  = '21' Then
           Begin
           Letra_1 := 'U';
           End
        Else If Posicao[5]  = '22' Then
           Begin
           Letra_1 := 'V';
           End
        Else If Posicao[5]  = '23' Then
           Begin
           Letra_1 := 'W';
           End
        Else If Posicao[5]  = '24' Then
           Begin
           Letra_1 := 'X';
           End
        Else If Posicao[5]  = '25' Then
           Begin
           Letra_1 := 'Y';
           End
        Else If Posicao[5]  = '26' Then
           Begin
           Letra_1 := 'Z';
           End
        Else
           Begin
           Letra_1 := 'A';
        End;

        //*** Obtem a 2a. Letra ***

        If Posicao[2]  = '01' Then
           Begin
           Letra_2 := 'A';
           End
        Else If Posicao[2]  = '02' Then
           Begin
           Letra_2 := 'B';
           End
        Else If Posicao[2]  = '03' Then
           Begin
           Letra_2 := 'C';
           End
        Else If Posicao[2]  = '04' Then
           Begin
           Letra_2 := 'D';
           End
        Else If Posicao[2]  = '05' Then
           Begin
           Letra_2 := 'E';
           End
        Else If Posicao[2]  = '06' Then
           Begin
           Letra_2 := 'F';
           End
        Else If Posicao[2]  = '07' Then
           Begin
           Letra_2 := 'G';
           End
        Else If Posicao[2]  = '08' Then
           Begin
           Letra_2 := 'H';
           End
        Else If Posicao[2]  = '09' Then
           Begin
           Letra_2 := 'I';
           End
        Else If Posicao[2]  = '10' Then
           Begin
           Letra_2 := 'J';
           End
        Else If Posicao[2]  = '11' Then
           Begin
           Letra_2 := 'K';
           End
        Else If Posicao[2]  = '12' Then
           Begin
           Letra_2 := 'L';
           End
        Else If Posicao[2]  = '13' Then
           Begin
           Letra_2 := 'M';
           End
        Else If Posicao[2]  = '14' Then
           Begin
           Letra_2 := 'N';
           End
        Else If Posicao[2]  = '15' Then
           Begin
           Letra_2 := 'O';
           End
        Else If Posicao[2]  = '16' Then
           Begin
           Letra_2 := 'P';
           End
        Else If Posicao[2]  = '17' Then
           Begin
           Letra_2 := 'Q';
           End
        Else If Posicao[2]  = '18' Then
           Begin
           Letra_2 := 'R';
           End
        Else If Posicao[2]  = '19' Then
           Begin
           Letra_2 := 'S';
           End
        Else If Posicao[2]  = '20' Then
           Begin
           Letra_2 := 'T';
           End
        Else If Posicao[2]  = '21' Then
           Begin
           Letra_2 := 'U';
           End
        Else If Posicao[2]  = '22' Then
           Begin
           Letra_2 := 'V';
           End
        Else If Posicao[2]  = '23' Then
           Begin
           Letra_2 := 'W';
           End
        Else If Posicao[2]  = '24' Then
           Begin
           Letra_2 := 'X';
           End
        Else If Posicao[2]  = '25' Then
           Begin
           Letra_2 := 'Y';
           End
        Else If Posicao[2]  = '26' Then
           Begin
           Letra_2 := 'Z';
           End
        Else
           Begin
           Letra_2 := 'A';
        End;

        //*** Obtem a 3a. Letra ***

        If Posicao[6]  = '01' Then
           Begin
           Letra_3 := 'A';
           End
        Else If Posicao[6]  = '02' Then
           Begin
           Letra_3 := 'B';
           End
        Else If Posicao[6]  = '03' Then
           Begin
           Letra_3 := 'C';
           End
        Else If Posicao[6]  = '04' Then
           Begin
           Letra_3 := 'D';
           End
        Else If Posicao[6]  = '05' Then
           Begin
           Letra_3 := 'E';
           End
        Else If Posicao[6]  = '06' Then
           Begin
           Letra_3 := 'F';
           End
        Else If Posicao[6]  = '07' Then
           Begin
           Letra_3 := 'G';
           End
        Else If Posicao[6]  = '08' Then
           Begin
           Letra_3 := 'H';
           End
        Else If Posicao[6]  = '09' Then
           Begin
           Letra_3 := 'I';
           End
        Else If Posicao[6]  = '10' Then
           Begin
           Letra_3 := 'J';
           End
        Else If Posicao[6]  = '11' Then
           Begin
           Letra_3 := 'K';
           End
        Else If Posicao[6]  = '12' Then
           Begin
           Letra_3 := 'L';
           End
        Else If Posicao[6]  = '13' Then
           Begin
           Letra_3 := 'M';
           End
        Else If Posicao[6]  = '14' Then
           Begin
           Letra_3 := 'N';
           End
        Else If Posicao[6]  = '15' Then
           Begin
           Letra_3 := 'O';
           End
        Else If Posicao[6]  = '16' Then
           Begin
           Letra_3 := 'P';
           End
        Else If Posicao[6]  = '17' Then
           Begin
           Letra_3 := 'Q';
           End
        Else If Posicao[6]  = '18' Then
           Begin
           Letra_3 := 'R';
           End
        Else If Posicao[6]  = '19' Then
           Begin
           Letra_3 := 'S';
           End
        Else If Posicao[6]  = '20' Then
           Begin
           Letra_3 := 'T';
           End
        Else If Posicao[6]  = '21' Then
           Begin
           Letra_3 := 'U';
           End
        Else If Posicao[6]  = '22' Then
           Begin
           Letra_3 := 'V';
           End
        Else If Posicao[6]  = '23' Then
           Begin
           Letra_3 := 'W';
           End
        Else If Posicao[6]  = '24' Then
           Begin
           Letra_3 := 'X';
           End
        Else If Posicao[6]  = '25' Then
           Begin
           Letra_3 := 'Y';
           End
        Else If Posicao[6]  = '26' Then
           Begin
           Letra_3 := 'Z';
           End
        Else
           Begin
           Letra_3 := 'A';
        End;

        Posicao_1.Text      := Posicao[0] + Posicao[4] + Posicao[1] + Posicao[5] + Posicao[2] + Posicao[6] + Posicao[3] + Posicao[7] + Letra_1 + Letra_2 + Letra_3;
        Nro_Licenca.Caption := Trim(Posicao_1.Text);
     End;

     //*** Licenca ***

     Str_Posicao := Posicao_1.Text;

     Posicao[0]  := Str_Posicao[1]+Str_Posicao[2];
     Posicao[1]  := Str_Posicao[3]+Str_Posicao[4];
     Posicao[2]  := Str_Posicao[5]+Str_Posicao[6];
     Posicao[3]  := Str_Posicao[7]+Str_Posicao[8];
     Posicao[4]  := Str_Posicao[9]+Str_Posicao[10];
     Posicao[5]  := Str_Posicao[11]+Str_Posicao[12];
     Posicao[6]  := Str_Posicao[13]+Str_Posicao[14];
     Posicao[7]  := Str_Posicao[15]+Str_Posicao[16];
     Posicao[8]  := Str_Posicao[17];
     Posicao[9]  := Str_Posicao[18];
     Posicao[10] := Str_Posicao[19];

     //*** Transforma a 1a. Letra ***

     If Posicao[8] = 'A' Then
        Begin
        Posicao[8] := '01';
        End
     Else If Posicao[8] = 'B' Then
        Begin
        Posicao[8] := '02';
        End
     Else If Posicao[8] = 'C' Then
        Begin
        Posicao[8] := '03';
        End
     Else If Posicao[8] = 'D' Then
        Begin
        Posicao[8] := '04';
        End
     Else If Posicao[8] = 'E' Then
        Begin
        Posicao[8] := '05';
        End
     Else If Posicao[8] = 'F' Then
        Begin
        Posicao[8] := '06';
        End
     Else If Posicao[8] = 'G' Then
        Begin
        Posicao[8] := '07';
        End
     Else If Posicao[8] = 'H' Then
        Begin
        Posicao[8] := '08';
        End
     Else If Posicao[8] = 'I' Then
        Begin
        Posicao[8] := '09';
        End
     Else If Posicao[8] = 'J' Then
        Begin
        Posicao[8] := '10';
        End
     Else If Posicao[8] = 'K' Then
        Begin
        Posicao[8] := '11';
        End
     Else If Posicao[8] = 'L' Then
        Begin
        Posicao[8] := '12';
        End
     Else If Posicao[8] = 'M' Then
        Begin
        Posicao[8] := '13';
        End
     Else If Posicao[8] = 'N' Then
        Begin
        Posicao[8] := '14';
        End
     Else If Posicao[8] = 'O' Then
        Begin
        Posicao[8] := '15';
        End
     Else If Posicao[8] = 'P' Then
        Begin
        Posicao[8] := '16';
        End
     Else If Posicao[8] = 'Q' Then
        Begin
        Posicao[8] := '17';
        End
     Else If Posicao[8] = 'R' Then
        Begin
        Posicao[8] := '18';
        End
     Else If Posicao[8] = 'S' Then
        Begin
        Posicao[8] := '19';
        End
     Else If Posicao[8] = 'T' Then
        Begin
        Posicao[8] := '20';
        End
     Else If Posicao[8] = 'U' Then
        Begin
        Posicao[8] := '21';
        End
     Else If Posicao[8] = 'V' Then
        Begin
        Posicao[8] := '22';
        End
     Else If Posicao[8] = 'W' Then
        Begin
        Posicao[8] := '23';
        End
     Else If Posicao[8] = 'X' Then
        Begin
        Posicao[8] := '24';
        End
     Else If Posicao[8] = 'Y' Then
        Begin
        Posicao[8] := '25';
        End
     Else If Posicao[8] = 'Z' Then
        Begin
        Posicao[8] := '26';
     End;

     //*** Transforma a 2a. Letra ***

     If Posicao[9] = 'A' Then
        Begin
        Posicao[9] := '01';
        End
     Else If Posicao[9] = 'B' Then
        Begin
        Posicao[9] := '02';
        End
     Else If Posicao[9] = 'C' Then
        Begin
        Posicao[9] := '03';
        End
     Else If Posicao[9] = 'D' Then
        Begin
        Posicao[9] := '04';
        End
     Else If Posicao[9] = 'E' Then
        Begin
        Posicao[9] := '05';
        End
     Else If Posicao[9] = 'F' Then
        Begin
        Posicao[9] := '06';
        End
     Else If Posicao[9] = 'G' Then
        Begin
        Posicao[9] := '07';
        End
     Else If Posicao[9] = 'H' Then
        Begin
        Posicao[9] := '08';
        End
     Else If Posicao[9] = 'I' Then
        Begin
        Posicao[9] := '09';
        End
     Else If Posicao[9] = 'J' Then
        Begin
        Posicao[9] := '10';
        End
     Else If Posicao[9] = 'K' Then
        Begin
        Posicao[9] := '11';
        End
     Else If Posicao[9] = 'L' Then
        Begin
        Posicao[9] := '12';
        End
     Else If Posicao[9] = 'M' Then
        Begin
        Posicao[9] := '13';
        End
     Else If Posicao[9] = 'N' Then
        Begin
        Posicao[9] := '14';
        End
     Else If Posicao[9] = 'O' Then
        Begin
        Posicao[9] := '15';
        End
     Else If Posicao[9] = 'P' Then
        Begin
        Posicao[9] := '16';
        End
     Else If Posicao[9] = 'Q' Then
        Begin
        Posicao[9] := '17';
        End
     Else If Posicao[9] = 'R' Then
        Begin
        Posicao[9] := '18';
        End
     Else If Posicao[9] = 'S' Then
        Begin
        Posicao[9] := '19';
        End
     Else If Posicao[9] = 'T' Then
        Begin
        Posicao[9] := '20';
        End
     Else If Posicao[9] = 'U' Then
        Begin
        Posicao[9] := '21';
        End
     Else If Posicao[9] = 'V' Then
        Begin
        Posicao[9] := '22';
        End
     Else If Posicao[9] = 'W' Then
        Begin
        Posicao[9] := '23';
        End
     Else If Posicao[9] = 'X' Then
        Begin
        Posicao[9] := '24';
        End
     Else If Posicao[9] = 'Y' Then
        Begin
        Posicao[9] := '25';
        End
     Else If Posicao[9] = 'Z' Then
        Begin
        Posicao[9] := '26';
     End;

     //*** Transforma a 3a. Letra ***

     If Posicao[10] = 'A' Then
        Begin
        Posicao[10] := '01';
        End
     Else If Posicao[10] = 'B' Then
        Begin
        Posicao[10] := '02';
        End
     Else If Posicao[10] = 'C' Then
        Begin
        Posicao[10] := '03';
        End
     Else If Posicao[10] = 'D' Then
        Begin
        Posicao[10] := '04';
        End
     Else If Posicao[10] = 'E' Then
        Begin
        Posicao[10] := '05';
        End
     Else If Posicao[10] = 'F' Then
        Begin
        Posicao[10] := '06';
        End
     Else If Posicao[10] = 'G' Then
        Begin
        Posicao[10] := '07';
        End
     Else If Posicao[10] = 'H' Then
        Begin
        Posicao[10] := '08';
        End
     Else If Posicao[10] = 'I' Then
        Begin
        Posicao[10] := '09';
        End
     Else If Posicao[10] = 'J' Then
        Begin
        Posicao[10] := '10';
        End
     Else If Posicao[10] = 'K' Then
        Begin
        Posicao[10] := '11';
        End
     Else If Posicao[10] = 'L' Then
        Begin
        Posicao[10] := '12';
        End
     Else If Posicao[10] = 'M' Then
        Begin
        Posicao[10] := '13';
        End
     Else If Posicao[10] = 'N' Then
        Begin
        Posicao[10] := '14';
        End
     Else If Posicao[10] = 'O' Then
        Begin
        Posicao[10] := '15';
        End
     Else If Posicao[10] = 'P' Then
        Begin
        Posicao[10] := '16';
        End
     Else If Posicao[10] = 'Q' Then
        Begin
        Posicao[10] := '17';
        End
     Else If Posicao[10] = 'R' Then
        Begin
        Posicao[10] := '18';
        End
     Else If Posicao[10] = 'S' Then
        Begin
        Posicao[10] := '19';
        End
     Else If Posicao[10] = 'T' Then
        Begin
        Posicao[10] := '20';
        End
     Else If Posicao[10] = 'U' Then
        Begin
        Posicao[10] := '21';
        End
     Else If Posicao[10] = 'V' Then
        Begin
        Posicao[10] := '22';
        End
     Else If Posicao[10] = 'W' Then
        Begin
        Posicao[10] := '23';
        End
     Else If Posicao[10] = 'X' Then
        Begin
        Posicao[10] := '24';
        End
     Else If Posicao[10] = 'Y' Then
        Begin
        Posicao[10] := '25';
        End
     Else If Posicao[10] = 'Z' Then
        Begin
        Posicao[10] := '26';
     End;

     //*** Efetua o C�lculo da Licen�a ***

     Posicao_Nro[0]  := Int(((StrToInt(Posicao[0]) / 7) * 100));
     Posicao_Nro[1]  := Int((StrToInt(Posicao[1]) / 7) * 100);
     Posicao_Nro[2]  := Int((StrToInt(Posicao[2]) / 7) * 100);
     Posicao_Nro[3]  := Int((StrToInt(Posicao[3]) / 7) * 100);
     Posicao_Nro[4]  := Int((StrToInt(Posicao[4]) / 7) * 100);
     Posicao_Nro[5]  := Int((StrToInt(Posicao[5]) / 7) * 100);
     Posicao_Nro[6]  := Int((StrToInt(Posicao[6]) / 7) * 100);
     Posicao_Nro[7]  := Int((StrToInt(Posicao[7]) / 7) * 100);
     Posicao_Nro[8]  := Int((StrToInt(Posicao[8]) / 7) * 100);
     Posicao_Nro[9]  := Int((StrToInt(Posicao[9]) / 7) * 100);
     Posicao_Nro[10] := Int((StrToInt(Posicao[10]) / 7) * 100);

     Calculo_1 := FloatToStr(Posicao_Nro[0]) + FloatToStr(Posicao_Nro[1]) + FloatToStr(Posicao_Nro[2]) + FloatToStr(Posicao_Nro[3]);
     Calculo_2 := FloatToStr(Posicao_Nro[4]) + FloatToStr(Posicao_Nro[5]) + FloatToStr(Posicao_Nro[6]) + FloatToStr(Posicao_Nro[7]);
     Calculo_3 := FloatToStr(Posicao_Nro[8]) + FloatToStr(Posicao_Nro[9]) + FloatToStr(Posicao_Nro[10]);

     Licenca   := FloatToStr((StrToFloat(Calculo_1) * 5)) + FloatToStr((StrToFloat(Calculo_3) * 5)) + FloatToStr((StrToFloat(Calculo_2) * 5));

     //*** Prepara a Conex�o com as Tabelas e Querys ***

     ConexaoBD.Conexao_Principal.Connected := False;
     ConexaoBD.Conexao_Principal.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\ConsulTEX\Tabelas\ConsulTEX.mdb;Mode=Read|Write;Persist Security Info=False';
     ConexaoBD.Conexao_Principal.Connected := True;

     //*** Carrega a Connex�o da Esta��o Local ***

     conexaoBD.SQL_Conexao.Close;
     conexaoBD.SQL_Conexao.SQL.Clear;
     conexaoBD.SQL_Conexao.SQL.Add('Select * from Conexao');
     conexaoBD.SQL_Conexao.Open;

     If conexaoBD.SQL_Conexao.RecordCount <= 0 Then
        Begin
        conexaoBD.SQL_Conexao.Close;
        conexaoBD.SQL_Conexao.SQL.Clear;
        conexaoBD.SQL_Conexao.SQL.Add('insert into Conexao(Conexao_caminho) values('+#39+'C:\ConsulTEX\Tabelas\'+#39+')');
        conexaoBD.SQL_Conexao.ExecSQL;

        conexaoBD.SQL_Conexao.Close;
        conexaoBD.SQL_Conexao.SQL.Clear;
        conexaoBD.SQL_Conexao.SQL.Add('Select * from Conexao');
        conexaoBD.SQL_Conexao.Open;
     End;

     If conexaoBD.SQL_Conexao.FieldValues['conexao_registro'] <> Null Then
        Begin
        Linha_Arq := conexaoBD.SQL_Conexao.FieldValues['conexao_registro'];
        End
     Else
        Begin
        Linha_Arq := '';
     End;

     Linha_Arq := Trim(Linha_Arq);

     //*** Fecha as Conex�es das Querys com o Access ***

     ConexaoBD.Conexao_Principal.Connected := False;

     //*** Valida o Nro do Registro ***

     If Tipo_Versao_Datatex = 'Full' Then
        Begin

        If Trim(Linha_Arq) <> Trim(Licenca) Then
           Begin
           Retorno := False;
           End
        Else
           Begin
           Retorno := True;
        End;

        End
     Else
        Begin
        Retorno := True;
     End;

     Verifica_Registro := Retorno;

end;

//******************
//*** Procedures ***
//******************

Procedure TLogin00.Gravar_Registro_Windows(const Key: String; const Value: Variant; KeyType: TKeyType);

var
  r: TRegistry;
begin
  // cria o objeto TRegistry
  r := TRegistry.Create;
  // conecta ao root diferente do padr�o
  r.RootKey := HKEY_LOCAL_MACHINE;
  try
    // abre a chave (no root selecionado)
    r.OpenKey('Software\Datatex\ConsulTEX', True);
    case KeyType of
      // grava o valor da chave em formato String
      ktString: r.WriteString(Key, Value);
      // grava o valor da chave em formato Boolean
      ktBoolean: r.WriteBool(Key, Value);
      // grava o valor da chave em formato Integer
      ktInteger: r.WriteInteger(Key, Value);
      // grava o valor da chave em formato Currency (moeda)
      ktCurrency: r.WriteCurrency(Key, Value);
      // grava o valor da chave em formato TDateTime (Data)
      ktDate: r.WriteDate(Key, Value);
      // grava o valor da chave em formato TDateTime (Hora)
      ktTime: r.WriteTime(Key, Value);
    end;
  finally
    r.Free;
  end;

end;

procedure Verifica_Senha();

var
   ValorSenha: String;

begin

{*** Verifica se o Usu�rio Existe ***}

     conexaoBD.SQL_Usuario.Close;
     conexaoBD.SQL_Usuario.SQL.Clear;
     conexaoBD.SQL_Usuario.SQL.Add('Select * from Usuario where Usuario_nome = "'+Trim(login00.login_usuario.Text)+'"');
     conexaoBD.SQL_Usuario.Open;

     if conexaoBD.SQL_Usuario.RecordCount <= 0 then
        begin

        login00.login_mensagem.Caption:='Login Recusado, Usu�rio Desconhecido...';

        Contador := Contador + 1;

        if Contador = 4 then
           begin
           Login00.Close;
        end;

        login00.login_usuario.SetFocus;
        Exit;

        end
     else
        begin

        ValorSenha := conexaoBD.SQL_UsuarioUsuario_Senha.AsString;

        if ValorSenha <> login00.login_senha.Text then
           begin

           login00.login_mensagem.Caption:='Login Recusado, Senha Inv�lida...';

           Contador := Contador + 1;

           if Contador = 4 then
              begin
              Login00.Close;
           end;

           login00.login_senha.SetFocus;
           Exit;

        end;

        Login00.Visible := False;

        Application.CreateForm(TCons02,Cons02);

//*** Carrega as Informa��es do M�dico Selecionado ***

        conexaoBD.SQL_Medico.Close;
        conexaoBD.SQL_Medico.SQL.Clear;
        conexaoBD.SQL_Medico.SQL.Add('select * from Medico Where Medico_nome = '+#39+Trim(login00.login_medico.Text)+#39);
        conexaoBD.SQL_Medico.Open;

        conexaoBD.SQL_Medico.First;

        Cons02.Caption := '- '+Trim(conexaoBD.SQL_Medico.FieldValues['Medico_nome']);
        Cons02.ConsulTEX_Medico_Crm.Text := conexaoBD.SQL_Medico.FieldValues['Medico_crm'];
        Cons02.ConsulTEX_Medico.Text     := conexaoBD.SQL_Medico.FieldValues['Medico_Nome'];

{*** Carrega as Op��es de Acesso do ConsulTEX ***}

        Cons02.ConsulTEX_Acesso_Usuario.Text     := conexaoBD.SQL_UsuarioUsuario_acesso_usuario.AsString;
        Cons02.ConsulTEX_Acesso_Paciente.Text    := conexaoBD.SQL_UsuarioUsuario_acesso_paciente.AsString;
        Cons02.ConsulTEX_Acesso_Prontuario.Text  := conexaoBD.SQL_UsuarioUsuario_acesso_paciente_prontuario.AsString;
        Cons02.ConsulTEX_Acesso_Observacoes.Text := conexaoBD.SQL_UsuarioUsuario_acesso_paciente_observacoes.AsString;
        Cons02.ConsulTEX_Acesso_Medico.Text      := conexaoBD.SQL_UsuarioUsuario_acesso_medico.AsString;
        Cons02.ConsulTEX_Acesso_Indicacao.Text   := conexaoBD.SQL_UsuarioUsuario_acesso_indicacao.AsString;
        Cons02.ConsulTEX_Acesso_Imp_Rec.Text     := conexaoBD.SQL_UsuarioUsuario_acesso_imp_rec.AsString;
        Cons02.ConsulTEX_Acesso_Imp_Ficha.Text   := conexaoBD.SQL_UsuarioUsuario_acesso_imp_ficha.AsString;
        Cons02.ConsulTEX_Acesso_Imp_Fat.Text     := conexaoBD.SQL_UsuarioUsuario_acesso_imp_fat.AsString;
        Cons02.ConsulTEX_Acesso_Imp_Env.Text     := conexaoBD.SQL_UsuarioUsuario_acesso_imp_env.AsString;
        Cons02.ConsulTEX_Acesso_Convenio.Text    := conexaoBD.SQL_UsuarioUsuario_acesso_convenio.AsString;
        Cons02.ConsulTEX_Acesso_Cid.Text         := conexaoBD.SQL_UsuarioUsuario_acesso_cid.AsString;
        Cons02.ConsulTEX_Acesso_Agenda.Text      := conexaoBD.SQL_UsuarioUsuario_acesso_agenda.AsString;
        Cons02.ConsulTEX_Acesso_Cirurgia.Text    := conexaoBD.SQL_UsuarioUsuario_acesso_cirurgia.AsString;
        Cons02.ConsulTEX_Acesso_Adicionais.Text  := conexaoBD.SQL_UsuarioUsuario_acesso_adicionais.AsString;

{*** Libera o Acesso ao ConsulTEX ***}

        Cons02.ShowModal;
        Cons02.Destroy;
     end;

     Login00.Close;
end;

procedure TLogin00.BTN_CancelarClick(Sender: TObject);
begin
     Login00.Close;
end;

procedure TLogin00.FormShow(Sender: TObject);
begin
    If Tipo_Versao_Datatex = 'Demo' Then
      begin
      login_mensagem.Caption := 'Utilizar como Usu�rio e Senha a palavra "datatex"';
    end;

    If Verifica_Controle_Acessos() Then
      begin
      If Verifica_Registro() Then
        Begin
        login_usuario.SetFocus;

        //*** Prepara o Caminho ***
        consultex_caminho.Text := Carrega_Conexao();

        //*** Prepara a Lista dos M�dicos ***
        Carrega_Lista_Medico();
        End
      Else
        Begin
        MSG_Erro('Este Sistema n�o est� autorizado a Funcionar neste Equipamento.'+Chr(13)+Chr(10)+Chr(13)+Chr(10)+'Entre em Contato com:'+Chr(13)+Chr(10)+Chr(13)+Chr(10)+'Datatex Inform�tica e Servi�os Ltda'+Chr(13)+Chr(10)+Chr(13)+Chr(10)+'Fone: (0xx11) 4476-9175'+Chr(13)+Chr(10)+'E-Mail: datatex@datatex.com.br');
        Application.CreateForm(TRegistraConsulTEX,RegistraConsulTEX);

        RegistraConsulTEX.Registro.Text := Trim(Nro_Licenca.Caption);

        RegistraConsulTEX.ShowModal;
        RegistraConsulTEX.Destroy;
        Login00.Close;
      End;
      end
    Else
      begin
      MSG_Erro('Seu Tempo de Utiliza��o da Vers�o ConsulTEX de Demonstra��o Expirou.'+Chr(13)+Chr(10)+Chr(13)+Chr(10)+'Entre em Contato com:'+Chr(13)+Chr(10)+Chr(13)+Chr(10)+'Datatex Inform�tica e Servi�os Ltda'+Chr(13)+Chr(10)+Chr(13)+Chr(10)+'Fone: (0xx11) 4476-9175'+Chr(13)+Chr(10)+'E-Mail: datatex@datatex.com.br');
      Login00.Close;
    end;
end;

procedure TLogin00.BTN_OkClick(Sender: TObject);
begin
     Verifica_Senha();
end;

procedure TLogin00.Label3Click(Sender: TObject);
begin
     Application.CreateForm(TConexao,Conexao);

     Conexao.conexao_caminho.Text := consultex_caminho.Text;

     Conexao.ShowModal;
     Conexao.Destroy;

     Login00.Close;
end;

procedure TLogin00.login_usuarioKeyPress(Sender: TObject; var Key: Char);
begin

if Key = #13 then
   begin
   login_senha.SetFocus;
end;

end;

procedure TLogin00.login_senhaKeyPress(Sender: TObject; var Key: Char);
begin

if Key = #13 then
   begin
   Verifica_Senha();
end;

end;

procedure TLogin00.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Fecha_Tudo();
end;

end.
