pageextension 50905 DIOTPurchInvExt extends "Purchase Invoice"
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