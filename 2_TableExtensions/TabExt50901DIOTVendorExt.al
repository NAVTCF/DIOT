tableextension 50901 DIOTVendorExt extends Vendor
{
    fields
    {
        field(50900;"DIOT - Third Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'DIOT - Nationality';
            OptionCaption = '04,05,15';
            OptionMembers = "04","05","15";
        } 
        field(50901;"DIOT - Transaction Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'DIOT - Transaction Type';
            OptionCaption = ' ,03,06,85';
            OptionMembers = " ","03","06","85";
        } 
        field(50902;"DIOT - Fiscal ID No."; Code[40])
        {
            DataClassification = CustomerContent;
            Caption = 'DIOT - Fiscal ID No.';
        } 
        field(50903;"DIOT - Foreign Name"; Text[43])
        {
            DataClassification = CustomerContent;
            Caption = 'DIOT - Foreign Name';
        } 
    }
    
    var
        myInt: Integer;
}