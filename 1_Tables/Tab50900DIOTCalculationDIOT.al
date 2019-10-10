table 50900 "DIOT Calculation"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1;"Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(2;"Line No"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No';
        }
        field(10;"Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
        }
        field(20;"Total Payment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Payment Amount';
        }
        field(30;"Total Payment Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Payment Amount (LCY)';
        }
        field(40;"Payment Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Document No.';
        }
        field(50;"Applied Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Applied Invoice No.';
        }
        field(60;"Transaction Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Type';
            OptionCaption = ' ,Professional Services,Property Leasing,Others';
            OptionMembers = " ","03","06","85";
        }
        field(70;"Total Invoice Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Invoice Amount';
        }
        field(80;"Total invoice Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total invoice Amount (LCY)';
        }
        field(90;"Applied Invoice Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Applied Invoice Amount';
        }
        field(100;"Applied Invoice Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Applied Invoice Amount (LCY)';
        }
        field(110;"Partial Factor"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Partial Factor';
        }
        field(120;"Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Line Amount';
        }
        field(130;"Line Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Line Amount (LCY)';
        }
        field(140;"% VAT"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '% VAT';
        }
        field(150;"Applied Line Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Applied Line Amount (LCY)';
        }
        field(160;"Base Line Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Base Line Amount (LCY)';
        }
        field(170;"VAT Line Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Line Amount (LCY)';
        }
        field(180;"Payment Currency"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Currency';
        }
        field(190;"Payment Currency Factor"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Currency Factor';
        }
        field(200;"VAT Prod. Posting Group"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Prod. Posting Group';
        }
        field(210;"VAT Bus. Posting Group"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Bus. Posting Group';
        }
    }
    
    keys
    {
        key(PK; "Entry No.","Line No")
        {
            Clustered = true;
        }
    }
    
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