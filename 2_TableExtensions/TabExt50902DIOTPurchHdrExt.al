tableextension 50902 DIOTPurchHdrExt extends "Purchase Header"
{
    fields
    {
        field(50901;"DIOT - Transaction Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'DIOT - Transaction Type';
            OptionCaption = ' ,03,06,85';
            OptionMembers = " ","03","06","85";
        } 
    }
    
    var
        myInt: Integer;
}