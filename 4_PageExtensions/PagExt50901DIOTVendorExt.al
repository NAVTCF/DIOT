pageextension 50901 DIOTVendorExt extends "Vendor Card"
{
    layout
    {
        addlast(Receiving)
        {
            group(DIOT)
            {
                field("DIOT - Third Type";"DIOT - Third Type")
                {
                    ApplicationArea = All;
                }
                field("DIOT - Transaction Type";"DIOT - Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("DIOT - Fiscal ID No.";"DIOT - Fiscal ID No.")
                {
                    ApplicationArea = All;
                }
                field("DIOT - Foreign Name";"DIOT - Foreign Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}