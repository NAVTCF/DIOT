tableextension 50904 DIOTVATPostSetup extends "VAT Posting Setup"
{
    fields
    {
        field(50900; "DIOT - Column No."; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18';
            OptionMembers = " ","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18";
        }
    }

    var
        myInt: Integer;
}