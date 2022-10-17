page 50104 ArithmeticOperation
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ArithmaticOperationn;

    layout
    {
        area(Content)
        {
            group(Input)
            {
                Caption = 'Input The Numbers';
                field("First Number"; Rec."First Number")
                {
                    ApplicationArea = All;
                    Editable = true;

                }
                field("Second Number"; Rec."Second Number")
                {
                    ApplicationArea = All;
                    Editable = true;

                }
                // field(Addition; Rec.Addition)
                // {
                //     ApplicationArea = All;

                // }
                // field(Subtraction; Rec.Subtraction)
                // {
                //     ApplicationArea = All;

                // }
                // field(Multiplication; Rec.Multiplication)
                // {
                //     ApplicationArea = All;

                // }
                // field(Division; Rec.Division)
                // {
                //     ApplicationArea = All;

                // }

            }

            group(Output)
            {
                Caption = 'Output';

                field(Addition; Rec.Addition)
                {
                    ApplicationArea = All;

                }
                field(Subtraction; Rec.Subtraction)
                {
                    ApplicationArea = All;

                }
                field(Multiplication; Rec.Multiplication)
                {
                    ApplicationArea = All;

                }
                field(Division; Rec.Division)
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
            action(Execute)
            {
                ApplicationArea = All;
                Caption = 'Execute';
                Image = ExecuteBatch;

                trigger OnAction()
                begin
                    Addition := "First Number" + "Second Number";
                    Subtraction := "First Number" - "Second Number";
                    Multiplication := "First Number" * "Second Number";
                    Division := "First Number" DIV "Second Number";

                end;
            }
        }
    }


    var
    // "First Number": Integer;
    // "Second Number": Integer;
    // Addition: Integer;
    // Subtraction: Integer;
    // Multiplication: Integer;
    // Division: Integer;

}