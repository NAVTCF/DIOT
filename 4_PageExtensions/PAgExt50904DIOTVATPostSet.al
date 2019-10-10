pageextension 50904 DIOTVATPostSetup extends "VAT Posting Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("DIOT - Column No.";"DIOT - Column No.")
            {
                ApplicationArea = All;
            }
        }
    }
}