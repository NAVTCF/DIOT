tableextension 50900 DIOTCountryRegionExt extends "Country/Region"
{
    fields
    {
        field(50900;"DIOT - Nationality"; Text[40])
        {
            DataClassification = CustomerContent;
            Caption = 'DIOT - Nationality';
        } 
    }
}