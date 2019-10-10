report 50900 "DIOT Calculation"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    ShowPrintStatus = false;

    dataset
    {
        dataitem(Root; "Detailed Vendor Ledg. Entry")
        {
            dataitem(InvoicesApplied; "Detailed Vendor Ledg. Entry")
            {
                DataItemTableView = sorting("Entry Type", "Document Type", "Initial Document Type", "Posting Date") order(ascending) where("Entry Type" = const(Application), "Document Type" = const(Payment), "Initial Document Type" = const(Invoice), Unapplied = const(false));
                DataItemLink = "Entry No." = field("Entry No.");
                dataitem(Invoice; "Vendor Ledger Entry")
                {
                    DataItemLink = "Entry No." = field("Vendor Ledger Entry No.");
                    CalcFields = Amount, "Amount (LCY)";
                    dataitem(PurchInvHeader; "Purch. Inv. Header")
                    {
                        DataItemTableView = sorting("No.") order(Ascending);
                        DataItemLink = "No." = field("Document No.");
                        dataitem(PurchInvLines; "Purch. Inv. Line")
                        {
                            DataItemLink = "Document No." = field("No.");
                            trigger OnAfterGetRecord()
                            var
                                PurchInvHeaderFactor: Decimal;
                                VATSetup: Record "VAT Posting Setup";
                            begin
                                GetPayment(DtldVendLedgEntry, InvoicesApplied);

                                DIOTCalculation.Init();

                                if DtldVendLedgEntry."Currency Code" = PurchInvHeader."Currency Code" then
                                    DIOTCalculation."Payment Currency Factor" := DtldVendLedgEntry."Amount (LCY)" / DtldVendLedgEntry.Amount
                                else
                                    DIOTCalculation."Payment Currency Factor" := Abs(Invoice."Amount (LCY)") / Abs(Invoice.Amount);

                                DIOTCalculation."Entry No." := InvoicesApplied."Entry No.";
                                DIOTCalculation."Line No" := GetLineNo;
                                DIOTCalculation."Vendor No." := PurchInvHeader."Buy-from Vendor No.";
                                DIOTCalculation."Total Payment Amount" := Abs(DtldVendLedgEntry.Amount);
                                DIOTCalculation."Total Payment Amount (LCY)" := Abs(DtldVendLedgEntry."Amount (LCY)");
                                DIOTCalculation."Payment Document No." := DtldVendLedgEntry."Document No.";
                                DIOTCalculation."Applied Invoice No." := Invoice."Document No.";
                                DIOTCalculation."Transaction Type" := PurchInvHeader."DIOT - Transaction Type";
                                DIOTCalculation."Total Invoice Amount" := Abs(Invoice.Amount);
                                DIOTCalculation."Total invoice Amount (LCY)" := Abs(Invoice.Amount * DIOTCalculation."Payment Currency Factor");
                                DIOTCalculation."Applied Invoice Amount" := Abs(InvoicesApplied.Amount);
                                DIOTCalculation."Applied Invoice Amount (LCY)" := Abs(InvoicesApplied.Amount) * DIOTCalculation."Payment Currency Factor";
                                DIOTCalculation."Partial Factor" := Abs(PurchInvLines."Amount Including VAT") / Abs(PurchInvHeader."Amount Including VAT");
                                DIOTCalculation."Line Amount" := Abs(PurchInvLines."Amount Including VAT");
                                DIOTCalculation."Line Amount (LCY)" := Abs(PurchInvLines."Amount Including VAT" * DIOTCalculation."Payment Currency Factor");

                                if VATSetup.GET(PurchInvLines."VAT Bus. Posting Group", PurchInvLines."VAT Prod. Posting Group") then
                                    DIOTCalculation."% VAT" := VATSetup."VAT %"
                                else
                                    DIOTCalculation."% VAT" := PurchInvLines."VAT %";

                                DIOTCalculation."Applied Line Amount (LCY)" := DIOTCalculation."Applied Invoice Amount (LCY)" * DIOTCalculation."Partial Factor";

                                if DIOTCalculation."% VAT" > 1 then
                                    DIOTCalculation."Base Line Amount (LCY)" := DIOTCalculation."Applied Line Amount (LCY)" / (1 + (DIOTCalculation."% VAT" / 100))
                                else
                                    DIOTCalculation."Base Line Amount (LCY)" := DIOTCalculation."Applied Line Amount (LCY)" / (1 + DIOTCalculation."% VAT");

                                DIOTCalculation."VAT Line Amount (LCY)" := DIOTCalculation."Applied Line Amount (LCY)" - DIOTCalculation."Base Line Amount (LCY)";
                                DIOTCalculation."Payment Currency" := DtldVendLedgEntry."Currency Code";
                                DIOTCalculation."VAT Prod. Posting Group" := PurchInvLines."VAT Prod. Posting Group";
                                DIOTCalculation."VAT Bus. Posting Group" := PurchInvLines."VAT Bus. Posting Group";
                                DIOTCalculation.Insert(true);
                                Commit();
                            end;
                        }
                    }
                    dataitem(InitBalInv; "VAT Entry")
                    {
                        DataItemLink = "Document No." = field("Document No."), "Bill-to/Pay-to No." = field("Vendor No.");
                        DataItemTableView = sorting("Document No.", "Posting Date") order(Ascending) WHERE("Document Type" = const(Invoice), Type = const(Purchase), Amount = filter(> 0));
                        trigger OnAfterGetRecord()
                        var
                            Vendors: Record Vendor;
                            VATSetup: Record "VAT Posting Setup";
                        begin
                            GetPayment(DtldVendLedgEntry, InvoicesApplied);
                            if PurchExist(Invoice."Document No.", Invoice."External Document No.", Invoice."Buy-from Vendor No.") then
                                CurrReport.SKIP;

                            DIOTCalculation.INIT;

                            DIOTCalculation."Payment Currency Factor" := Abs(Invoice."Amount (LCY)") / Abs(Invoice.Amount);
                            DIOTCalculation."Entry No." := InvoicesApplied."Entry No.";
                            DIOTCalculation."Line No" := GetLineNo;
                            DIOTCalculation."Vendor No." := Invoice."Buy-from Vendor No.";
                            DIOTCalculation."Total Payment Amount" := Abs(DtldVendLedgEntry.Amount);
                            DIOTCalculation."Total Payment Amount (LCY)" := Abs(DtldVendLedgEntry."Amount (LCY)");
                            DIOTCalculation."Payment Document No." := DtldVendLedgEntry."Document No.";
                            DIOTCalculation."Applied Invoice No." := Invoice."Document No.";

                            if Vendors.GET(Invoice."Buy-from Vendor No.") then DIOTCalculation."Transaction Type" := Vendors."DIOT - Transaction Type";

                            DIOTCalculation."Total Invoice Amount" := Abs(Invoice.Amount);
                            DIOTCalculation."Total invoice Amount (LCY)" := Abs(Invoice.Amount * DIOTCalculation."Payment Currency Factor");
                            DIOTCalculation."Applied Invoice Amount" := Abs(InvoicesApplied.Amount);
                            DIOTCalculation."Applied Invoice Amount (LCY)" := Abs(InvoicesApplied.Amount) * DIOTCalculation."Payment Currency Factor";
                            DIOTCalculation."Partial Factor" := 1;
                            DIOTCalculation."Line Amount" := Abs(Invoice.Amount);
                            DIOTCalculation."Line Amount (LCY)" := Abs(Invoice.Amount * DIOTCalculation."Payment Currency Factor");

                            if VATSetup.GET(InitBalInv."VAT Bus. Posting Group", InitBalInv."VAT Prod. Posting Group") then DIOTCalculation."% VAT" := VATSetup."VAT %";

                            DIOTCalculation."Applied Line Amount (LCY)" := DIOTCalculation."Applied Invoice Amount (LCY)" * DIOTCalculation."Partial Factor";

                            if DIOTCalculation."% VAT" > 1 then
                                DIOTCalculation."Base Line Amount (LCY)" := DIOTCalculation."Applied Line Amount (LCY)" / (1 + (DIOTCalculation."% VAT" / 100))
                            else
                                DIOTCalculation."Base Line Amount (LCY)" := DIOTCalculation."Applied Line Amount (LCY)" / (1 + DIOTCalculation."% VAT");

                            DIOTCalculation."VAT Line Amount (LCY)" := DIOTCalculation."Applied Line Amount (LCY)" - DIOTCalculation."Base Line Amount (LCY)";
                            DIOTCalculation."Payment Currency" := DtldVendLedgEntry."Currency Code";
                            DIOTCalculation."VAT Prod. Posting Group" := InitBalInv."VAT Prod. Posting Group";
                            DIOTCalculation."VAT Bus. Posting Group" := InitBalInv."VAT Bus. Posting Group";
                            DIOTCalculation.Insert();
                            Commit();
                        end;
                    }
                }
            }
            dataitem(InvoicesApplied2; "Detailed Vendor Ledg. Entry")
            {
                DataItemTableView = sorting("Entry Type", "Document Type", "Initial Document Type", "Posting Date") order(Ascending) where("Entry Type" = const(Application), "Document Type" = const(Invoice), "Initial Document Type" = const(Payment), Unapplied = const(false));
                DataItemLink = "Entry No." = field("Entry No.");
                dataitem(Invoice2; "Vendor Ledger Entry")
                {
                    DataItemLink = "Entry No." = FIELD("Applied Vend. Ledger Entry No.");
                    CalcFields = Amount, "Amount (LCY)";
                    dataitem(PurchInvHeader2; "Purch. Inv. Header")
                    {
                        DataItemTableView = sorting("No.") order(Ascending);
                        DataItemLink = "No." = field("Document No.");
                        CalcFields = Amount, "Amount Including VAT";
                        dataitem(PurchInvLines2; "Purch. Inv. Line")
                        {
                            DataItemLink = "Document No." = FIELD("No.");
                            trigger OnAfterGetRecord()
                            var
                                VATSetup: Record "VAT Posting Setup";
                            begin
                                GetPayment(DtldVendLedgEntry, InvoicesApplied2);
                                DIOTCalculation.INIT;

                                if DtldVendLedgEntry."Currency Code" = PurchInvHeader2."Currency Code" then
                                    DIOTCalculation."Payment Currency Factor" := DtldVendLedgEntry."Amount (LCY)" / DtldVendLedgEntry.Amount
                                else
                                    DIOTCalculation."Payment Currency Factor" := Abs(Invoice2."Amount (LCY)") / Abs(Invoice2.Amount);

                                DIOTCalculation."Entry No." := InvoicesApplied2."Entry No.";
                                DIOTCalculation."Line No" := GetLineNo;
                                DIOTCalculation."Vendor No." := PurchInvHeader2."Buy-from Vendor No.";
                                DIOTCalculation."Total Payment Amount" := Abs(DtldVendLedgEntry.Amount);
                                DIOTCalculation."Total Payment Amount (LCY)" := Abs(DtldVendLedgEntry."Amount (LCY)");
                                DIOTCalculation."Payment Document No." := DtldVendLedgEntry."Document No.";
                                DIOTCalculation."Applied Invoice No." := Invoice2."Document No.";
                                DIOTCalculation."Transaction Type" := PurchInvHeader2."DIOT - Transaction Type";
                                DIOTCalculation."Total Invoice Amount" := Abs(Invoice2.Amount);
                                DIOTCalculation."Total invoice Amount (LCY)" := Abs(Invoice2.Amount * DIOTCalculation."Payment Currency Factor");
                                DIOTCalculation."Applied Invoice Amount" := Abs(InvoicesApplied2.Amount);
                                DIOTCalculation."Applied Invoice Amount (LCY)" := Abs(InvoicesApplied2.Amount) * DIOTCalculation."Payment Currency Factor";
                                DIOTCalculation."Partial Factor" := Abs(PurchInvLines2."Amount Including VAT") / Abs(PurchInvHeader2."Amount Including VAT");
                                DIOTCalculation."Line Amount" := Abs(PurchInvLines2."Amount Including VAT");
                                DIOTCalculation."Line Amount (LCY)" := Abs(PurchInvLines2."Amount Including VAT" * DIOTCalculation."Payment Currency Factor");

                                if VATSetup.GET(PurchInvLines2."VAT Bus. Posting Group", PurchInvLines2."VAT Prod. Posting Group") then
                                    DIOTCalculation."% VAT" := VATSetup."VAT %"
                                else
                                    DIOTCalculation."% VAT" := PurchInvLines2."VAT %";

                                DIOTCalculation."Applied Line Amount (LCY)" := DIOTCalculation."Applied Invoice Amount (LCY)" * DIOTCalculation."Partial Factor";

                                if DIOTCalculation."% VAT" > 1 then
                                    DIOTCalculation."Base Line Amount (LCY)" := DIOTCalculation."Applied Line Amount (LCY)" / (1 + (DIOTCalculation."% VAT" / 100))
                                else
                                    DIOTCalculation."Base Line Amount (LCY)" := DIOTCalculation."Applied Line Amount (LCY)" / (1 + DIOTCalculation."% VAT");

                                DIOTCalculation."VAT Line Amount (LCY)" := DIOTCalculation."Applied Line Amount (LCY)" - DIOTCalculation."Base Line Amount (LCY)";
                                DIOTCalculation."Payment Currency" := DtldVendLedgEntry."Currency Code";
                                DIOTCalculation."VAT Prod. Posting Group" := PurchInvLines2."VAT Prod. Posting Group";
                                DIOTCalculation."VAT Bus. Posting Group" := PurchInvLines2."VAT Bus. Posting Group";
                                DIOTCalculation.Insert();
                                Commit();
                            end;
                        }
                    }
                    dataitem(InitBalInv2; "VAT Entry")
                    {
                        DataItemTableView = sorting("Document No.", "Posting Date") order(Ascending) where("Document Type" = const(Invoice), Type = const(Purchase), Amount = filter(> 0));
                        DataItemLink = "Bill-to/Pay-to No." = field("Vendor No."), "Document No." = field("Document No.");
                        trigger OnAfterGetRecord()
                        var
                            Vendors: Record Vendor;
                            VATSetup: Record "VAT Posting Setup";
                        begin
                            GetPayment(DtldVendLedgEntry, InvoicesApplied2);
                            if PurchExist(Invoice2."Document No.", Invoice2."External Document No.", Invoice2."Buy-from Vendor No.") then
                                CurrReport.SKIP;

                            DIOTCalculation.INIT;

                            DIOTCalculation."Payment Currency Factor" := Abs(Invoice2."Amount (LCY)") / Abs(Invoice2.Amount);
                            DIOTCalculation."Entry No." := InvoicesApplied2."Entry No.";
                            DIOTCalculation."Line No" := GetLineNo;
                            DIOTCalculation."Vendor No." := Invoice2."Buy-from Vendor No.";
                            DIOTCalculation."Total Payment Amount" := Abs(DtldVendLedgEntry.Amount);
                            DIOTCalculation."Total Payment Amount (LCY)" := Abs(DtldVendLedgEntry."Amount (LCY)");
                            DIOTCalculation."Payment Document No." := DtldVendLedgEntry."Document No.";
                            DIOTCalculation."Applied Invoice No." := Invoice2."Document No.";

                            if Vendors.GET(Invoice2."Buy-from Vendor No.") then DIOTCalculation."Transaction Type" := Vendors."DIOT - Transaction Type";

                            DIOTCalculation."Total Invoice Amount" := Abs(Invoice2.Amount);
                            DIOTCalculation."Total invoice Amount (LCY)" := Abs(Invoice2.Amount * DIOTCalculation."Payment Currency Factor");
                            DIOTCalculation."Applied Invoice Amount" := Abs(InvoicesApplied2.Amount);
                            DIOTCalculation."Applied Invoice Amount (LCY)" := Abs(InvoicesApplied2.Amount) * DIOTCalculation."Payment Currency Factor";
                            DIOTCalculation."Partial Factor" := 1;
                            DIOTCalculation."Line Amount" := Abs(Invoice2.Amount);
                            DIOTCalculation."Line Amount (LCY)" := Abs(Invoice2.Amount * DIOTCalculation."Payment Currency Factor");

                            if VATSetup.GET(InitBalInv2."VAT Bus. Posting Group", InitBalInv2."VAT Prod. Posting Group") then DIOTCalculation."% VAT" := VATSetup."VAT %";

                            DIOTCalculation."Applied Line Amount (LCY)" := DIOTCalculation."Applied Invoice Amount (LCY)" * DIOTCalculation."Partial Factor";

                            if DIOTCalculation."% VAT" > 1 then
                                DIOTCalculation."Base Line Amount (LCY)" := DIOTCalculation."Applied Line Amount (LCY)" / (1 + (DIOTCalculation."% VAT" / 100))
                            else
                                DIOTCalculation."Base Line Amount (LCY)" := DIOTCalculation."Applied Line Amount (LCY)" / (1 + DIOTCalculation."% VAT");

                            DIOTCalculation."VAT Line Amount (LCY)" := DIOTCalculation."Applied Line Amount (LCY)" - DIOTCalculation."Base Line Amount (LCY)";
                            DIOTCalculation."Payment Currency" := DtldVendLedgEntry."Currency Code";
                            DIOTCalculation."VAT Prod. Posting Group" := InitBalInv2."VAT Prod. Posting Group";
                            DIOTCalculation."VAT Bus. Posting Group" := InitBalInv2."VAT Bus. Posting Group";
                            DIOTCalculation.Insert();
                            Commit();
                        end;
                    }
                }
            }
        }
    }

    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        DIOTCalculation: Record "DIOT Calculation";
        DateRange: Text;

    trigger OnPostReport()
    begin
        Integration;
    end;

    procedure Integration()
    var
        DIOTCalc: Record "DIOT Calculation";
        DIOT: Record DIOT;
        Country_Region: Record "Country/Region";
        Vendor: Record Vendor;
        VATProdPostingGp: Record "VAT Product Posting Group";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        DIOT.Reset();
        DIOT.DeleteAll();
        Commit();

        DIOTCalc.Reset();
        DIOTCalc.SETCURRENTKEY("Vendor No.", "Transaction Type");
        if DIOTCalc.FIND('-') then
            repeat
                if Vendor.GET(DIOTCalc."Vendor No.") then
                    if DIOT.GET(Vendor."DIOT - Third Type", DIOTCalc."Transaction Type", Vendor."VAT Registration No.", Vendor."DIOT - Fiscal ID No.") or
                        DIOT.GET(Vendor."DIOT - Third Type", Vendor."DIOT - Transaction Type", Vendor."VAT Registration No.", Vendor."DIOT - Fiscal ID No.") then begin
                        if VATPostingSetup.GET(DIOTCalculation."VAT Bus. Posting Group", DIOTCalc."VAT Prod. Posting Group") then
                            case VATPostingSetup."DIOT - Column No." of
                                VATPostingSetup."DIOT - Column No."::"1":
                                    DIOT."Column 1" := DIOT."Column 1" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"2":
                                    DIOT."Column 2" := DIOT."Column 2" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"3":
                                    DIOT."Column 3" := DIOT."Column 3" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"4":
                                    DIOT."Column 4" := DIOT."Column 4" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"5":
                                    DIOT."Column 5" := DIOT."Column 5" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"6":
                                    DIOT."Column 6" := DIOT."Column 6" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"7":
                                    DIOT."Column 7" := DIOT."Column 7" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"8":
                                    DIOT."Column 8" := DIOT."Column 8" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"9":
                                    DIOT."Column 9" := DIOT."Column 9" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"10":
                                    DIOT."Column 10" := DIOT."Column 10" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"11":
                                    DIOT."Column 11" := DIOT."Column 11" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"12":
                                    DIOT."Column 12" := DIOT."Column 12" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"13":
                                    DIOT."Column 13" := DIOT."Column 13" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"14":
                                    DIOT."Column 14" := DIOT."Column 14" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"15":
                                    DIOT."Column 15" := DIOT."Column 15" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"16":
                                    DIOT."Column 16" := DIOT."Column 16" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"17":
                                    DIOT."Column 17" := DIOT."Column 17" + DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"18":
                                    DIOT."Column 18" := DIOT."Column 18" + DIOTCalc."Base Line Amount (LCY)";
                            end;
                        DIOT.Modify(true);

                    end else begin
                        DIOT.Init();
                        DIOT."Third Type" := Vendor."DIOT - Third Type";
                        DIOT."Transaction Type" := DIOTCalc."Transaction Type";

                        if DIOT."Transaction Type" = 0 then DIOT."Transaction Type" := Vendor."DIOT - Transaction Type";

                        DIOT."VAT Registration No" := Vendor."VAT Registration No.";
                        DIOT."Fiscal ID" := Vendor."DIOT - Fiscal ID No.";
                        DIOT."Foreign Name" := Vendor."DIOT - Foreign Name";

                        if StrLen(DIOT."Fiscal ID") > 0 then DIOT."Residency Country" := Vendor."Country/Region Code";

                        if Country_Region.Get(Vendor."Country/Region Code") then DIOT.Nationality := Country_Region."DIOT - Nationality";

                        if VATPostingSetup.Get(DIOTCalculation."VAT Bus. Posting Group", DIOTCalc."VAT Prod. Posting Group") then
                            case VATPostingSetup."DIOT - Column No." of
                                VATPostingSetup."DIOT - Column No."::"1":
                                    DIOT."Column 1" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"2":
                                    DIOT."Column 2" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"3":
                                    DIOT."Column 3" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"4":
                                    DIOT."Column 4" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"5":
                                    DIOT."Column 5" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"6":
                                    DIOT."Column 6" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"7":
                                    DIOT."Column 7" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"8":
                                    DIOT."Column 8" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"9":
                                    DIOT."Column 9" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"10":
                                    DIOT."Column 10" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"11":
                                    DIOT."Column 11" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"12":
                                    DIOT."Column 12" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"13":
                                    DIOT."Column 13" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"14":
                                    DIOT."Column 14" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"15":
                                    DIOT."Column 15" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"16":
                                    DIOT."Column 16" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"17":
                                    DIOT."Column 17" := DIOTCalc."Base Line Amount (LCY)";
                                VATPostingSetup."DIOT - Column No."::"18":
                                    DIOT."Column 18" := DIOTCalc."Base Line Amount (LCY)";
                            end;
                        DIOT.Insert();
                    end;
            until DIOTCalc.Next() = 0;

        //We drop out all line with 0 in all columns
        DIOT.Reset();
        if DIOT.FindFirst() then
            repeat
                if (DIOT."Column 1" = 0) and
                    (DIOT."Column 2" = 0) and
                    (DIOT."Column 3" = 0) and
                    (DIOT."Column 4" = 0) and
                    (DIOT."Column 5" = 0) and
                    (DIOT."Column 6" = 0) and
                    (DIOT."Column 7" = 0) and
                    (DIOT."Column 8" = 0) and
                    (DIOT."Column 9" = 0) and
                    (DIOT."Column 10" = 0) and
                    (DIOT."Column 11" = 0) and
                    (DIOT."Column 12" = 0) and
                    (DIOT."Column 13" = 0) and
                    (DIOT."Column 14" = 0) and
                    (DIOT."Column 15" = 0) and
                    (DIOT."Column 16" = 0) and
                    (DIOT."Column 17" = 0) and
                    (DIOT."Column 18" = 0) then
                    DIOT.Delete();
            until DIOT.Next() = 0;
    end;

    procedure PurchExist(DocumentNo: Code[20]; DocumentExtNo: Code[20]; VendorNo: Code[20]) result: Boolean;
    var
        L_PurchInvHeader: Record "Purch. Inv. Header";
    begin
        L_PurchInvHeader.Reset();
        L_PurchInvHeader.SETRANGE("Buy-from Vendor No.", VendorNo);
        L_PurchInvHeader.SETRANGE("No.", DocumentNo);
        if L_PurchInvHeader.FIND('-') then exit(true);
        exit(false);
    end;

    procedure GetPayment(var Payment: Record "Detailed Vendor Ledg. Entry"; InvoiceApplied: Record "Detailed Vendor Ledg. Entry")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        Payment.Reset();
        Payment.SetRange("Entry Type", Payment."Entry Type"::"Initial Entry");
        Payment.SetRange("Document Type", Payment."Document Type"::Payment);
        Payment.SetRange(Unapplied, FALSE);
        if (InvoiceApplied."Entry Type" = InvoiceApplied."Entry Type"::Application) and
        (InvoiceApplied."Document Type" = InvoiceApplied."Document Type"::Payment) and
        (InvoiceApplied."Initial Document Type" = InvoiceApplied."Initial Document Type"::Invoice) then begin
            Payment.SetRange("Vendor Ledger Entry No.", InvoiceApplied."Applied Vend. Ledger Entry No.");
        end;

        if (InvoiceApplied."Entry Type" = InvoiceApplied."Entry Type"::Application) and
        (InvoiceApplied."Document Type" = InvoiceApplied."Document Type"::Invoice) and
        (InvoiceApplied."Initial Document Type" = InvoiceApplied."Initial Document Type"::Payment) then begin
            Payment.SetRange("Vendor Ledger Entry No.", InvoiceApplied."Vendor Ledger Entry No.");
        end;

        Payment.FindFirst();
    end;

    procedure GetLineNo() lineno: Integer
    var
        DIOTCalculation: Record "DIOT Calculation";
    begin
        DIOTCalculation.Reset();
        if DIOTCalculation.FindLast() then exit(10000 * (DIOTCalculation.COUNT + 1));
        exit(10000);
    end;
}