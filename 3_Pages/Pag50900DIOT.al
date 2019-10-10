page 50900 DIOT
{

    PageType = List;
    SourceTable = DIOT;
    Caption = 'DIOT';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Third Type"; "Third Type")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No"; "VAT Registration No")
                {
                    ApplicationArea = All;
                }
                field("Fiscal ID"; "Fiscal ID")
                {
                    ApplicationArea = All;
                }
                field("Foreign Name"; "Foreign Name")
                {
                    ApplicationArea = All;
                }
                field("Residency Country"; "Residency Country")
                {
                    ApplicationArea = All;
                }
                field(Nationality; Nationality)
                {
                    ApplicationArea = All;
                }
                field("Column 1"; "Column 1")
                {
                    ApplicationArea = All;
                }
                field("Column 2"; "Column 2")
                {
                    ApplicationArea = All;
                }
                field("Column 3"; "Column 3")
                {
                    ApplicationArea = All;
                }
                field("Column 4"; "Column 4")
                {
                    ApplicationArea = All;
                }
                field("Column 5"; "Column 5")
                {
                    ApplicationArea = All;
                }
                field("Column 6"; "Column 6")
                {
                    ApplicationArea = All;
                }
                field("Column 7"; "Column 7")
                {
                    ApplicationArea = All;
                }
                field("Column 8"; "Column 8")
                {
                    ApplicationArea = All;
                }
                field("Column 9"; "Column 9")
                {
                    ApplicationArea = All;
                }
                field("Column 10"; "Column 10")
                {
                    ApplicationArea = All;
                }
                field("Column 11"; "Column 11")
                {
                    ApplicationArea = All;
                }
                field("Column 12"; "Column 12")
                {
                    ApplicationArea = All;
                }
                field("Column 13"; "Column 13")
                {
                    ApplicationArea = All;
                }
                field("Column 14"; "Column 14")
                {
                    ApplicationArea = All;
                }
                field("Column 15"; "Column 15")
                {
                    ApplicationArea = All;
                }
                field("<Column 16>"; "Column 16")
                {
                    ApplicationArea = All;
                }
                field("Column 17"; "Column 17")
                {
                    ApplicationArea = All;
                }
                field("Column 18"; "Column 18")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Calculation)
            {
                ApplicationArea = All;
                Image = Calculate;

                trigger OnAction()
                begin
                    DIOTCalculation.Reset();
                    DIOTCalculation.DeleteAll();
                    DIOT.Reset();
                    DIOT.DeleteAll();
                    Commit();
                    Report.Run(50900);
                end;
            }
            action("Export TXT")
            {
                ApplicationArea = All;
                Image = ExportFile;

                trigger OnAction()
                begin
                    DIOT.Reset();
                    if DIOT.Count = 0 then Error(Error_Export_TXT);
                    DIOTGenerating.GetTxt();
                end;
            }
            action("Export XML")
            {
                ApplicationArea = All;
                Image = XMLFile;

                trigger OnAction()
                begin
                    DIOT.Reset();
                    if DIOT.Count =0 then Error(Error_Export_XML);
                end;
            }
            action("View Detail")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
    var
        "Start Date": Date;
        "End Date": Date;
        "Vendor Range":	Text[50];
        //Tools;   Codeunit ApplicationManagement
        Period: Integer;
        DIOTCalculation: Record "DIOT Calculation";
        DIOT:	Record  DIOT;
        DIOTGenerating: Codeunit "DIOT Functions";
        Error_Date: Label 'Debe especificar el rango de calculo';
        Error_Export_TXT: Label 'Primero debe tener un calculo realizado';
        Error_Export_XML: Label 'Primero debe tener un calculo realizado';
}
