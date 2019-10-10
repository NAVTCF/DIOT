table 50901 DIOT
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(10;"Third Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'DIOT - Nationality';
            OptionCaption = '04,05,15';
            OptionMembers = "04","05","15";
        }
        field(20;"Transaction Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Type';
            OptionCaption = ' ,Professional Services,Property Leasing,Others';
            OptionMembers = " ","03","06","85";
        }
        field(30;"VAT Registration No"; Code[13])
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Registration No';
        }
        field(40;"Fiscal ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Fiscal ID';
        }
        field(50;"Foreign Name"; Text[43])
        {
            DataClassification = CustomerContent;
            Caption = 'Foreign Name';
        }
        field(60;"Residency Country"; Code[2])
        {
            DataClassification = CustomerContent;
            Caption = 'Residency Country';
        }
        field(70;"Nationality"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Nationality';
        }
        field(80;"Column 1"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 1';
        }
        field(90;"Column 2"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 2';
        }
        field(100;"Column 3"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 3';
        }
        field(110;"Column 4"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 4';
        }
        field(120;"Column 5"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 5';
        }
        field(130;"Column 6"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 6';
        }
        field(140;"Column 7"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 7';
        }
        field(150;"Column 8"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 8';
        }
        field(160;"Column 9"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 9';
        }
        field(170;"Column 10"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 10';
        }
        field(180;"Column 11"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 11';
        }
        field(190;"Column 12"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 12';
        }
        field(200;"Column 13"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 13';
        }
        field(210;"Column 14"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 14';
        }
        field(230;"Column 15"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 15';
        }
        field(240;"Column 16"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 16';
        }
        field(250;"Column 17"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 17';
        }
        field(260;"Column 18"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Column 18';
        }
    }
    
    keys
    {
        key(PK; "Third Type","Transaction Type","VAT Registration No","Fiscal ID")
        {
            Clustered = true;
        }
    }
    
    var
        myInt: Integer;
    
    trigger OnInsert()
    begin
        
    end;
    
    trigger OnModify()
    begin
        
    end;
    
    trigger OnDelete()
    begin
        
    end;
    
    trigger OnRename()
    begin
        
    end;
    
}