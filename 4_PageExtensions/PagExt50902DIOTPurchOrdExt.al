pageextension 50902 DIOTPurchOrdExt extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field("DIOT - Transaction Type";"DIOT - Transaction Type")
            {
                ApplicationArea = All;
            }
        }
    }
}