table 50101 ArithmaticOperationn
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Operation ID"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; "First Number"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Second Number"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(4; Addition; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(5; Subtraction; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(6; Multiplication; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(7; Division; Integer)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(pk; "Operation ID")
        {
            Clustered = true;

        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}