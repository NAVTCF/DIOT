codeunit 50900 "DIOT Functions"
{
    trigger OnRun()
    begin
        
    end;
    
    var
        myInt: Integer;
    
    procedure GetTxt()
    var
        File: File; 
        Linea: Text[1024];
        DIOT: Record DIOT;
        Blob: Record TempBlob temporary;
        FileManagement: Codeunit "File Management";
        FileName: Text;
        RK: Char;
        LN: Char;
        Out: OutStream ;
        // StreamWriter: DotNet System.IO.StreamWriter.'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089';
        // encoding: DotNet System.Text.Encoding.'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089';

    begin
        RK := 13;
        LN := 10;
        // FileName :=  FileManagement.ServerTempFileName('DIOT');
        // File.CREATE(FileName);
        // File.CREATEOUTSTREAM(Out);

        // StreamWriter := StreamWriter.StreamWriter(Out,encoding.Default);

        DIOT.RESET;
        IF DIOT.FIND('-') THEN
        REPEAT

            OutStr.WriteText(CASE DIOT."Third Type" OF
                DIOT."Third Type"::"04": Linea := Linea + '04|';
                DIOT."Third Type"::"05": Linea := Linea + '05|';
                DIOT."Third Type"::"15": Linea := Linea + '15|';
                ELSE Linea := '|';
            END;
            CASE DIOT."Transaction Type" OF
                DIOT."Transaction Type"::"03": Linea := Linea + '03|';
                DIOT."Transaction Type"::"06": Linea := Linea + '06|';
                DIOT."Transaction Type"::"85": Linea := Linea + '85|';
                ELSE Linea:= Linea + '|';
            END;
            //Build the line to write to file
            Linea := Linea + DIOT."VAT Registration No" + '|' + DIOT."Fiscal ID" + '|' + DIOT."Foreign Name" + '|'+DIOT."Residency Country" + '|' + DIOT.Nationality;
            Linea := Linea + '|' + GetNumber(DIOT."Column 1") + '|' + GetNumber(DIOT."Column 2") + '|'+ GetNumber(DIOT."Column 3") + '|'+ GetNumber(DIOT."Column 4");
            Linea := Linea + '|' + GetNumber(DIOT."Column 5") + '|' + GetNumber(DIOT."Column 17") + '|'+ GetNumber(DIOT."Column 6") + '|'+ GetNumber(DIOT."Column 18"); //OAM_DIOT_1
            Linea := Linea + '|' + GetNumber(DIOT."Column 7") + '|' + GetNumber(DIOT."Column 8") + '|' + GetNumber(DIOT."Column 9") + '|' + GetNumber(DIOT."Column 10");
            Linea := Linea + '|' + GetNumber(DIOT."Column 11") + '|'+ GetNumber(DIOT."Column 12") + '|' + GetNumber(DIOT."Column 13") + '|' + GetNumber(DIOT."Column 14");
            Linea := Linea + '|' + GetNumber(DIOT."Column 15") + '|'+ GetNumber(DIOT."Column 16") + FORMAT(RK) + FORMAT(LN);
            // StreamWriter.Write(Linea);
            CLEAR(Linea);
        UNTIL DIOT.NEXT =0;
        // StreamWriter.Close();
        // File.CLOSE();



    end;
    procedure GetNumber(Amount : Decimal) AmountToText : Text[10]
    var
        myInt: Integer;
    begin
        if Amount =0 then exit('');
        exit(Format(Round(Amount,1,'='),0,2));
    end;
    procedure DIOTCalculation()
    var
        myInt: Integer;
    begin
        
    end;
    procedure DIOTTxtExport()
    var
        myInt: Integer;
    begin
        
    end;
}