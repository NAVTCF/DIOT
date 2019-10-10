pageextension 50903 DIOTPurchInvhdrExt extends "Posted Purchase Invoice"
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