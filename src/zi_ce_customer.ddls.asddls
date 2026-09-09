@EndUserText.label: 'Custom Entity for Customer'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CE_CUSTOMER'
@UI: {
  headerInfo: { typeName: 'Customer',
                typeNamePlural: 'Customers',
                title: { type: #STANDARD, label: 'Customer ID', value: 'CustomerID' },
                description: { type: #STANDARD, label: 'Customer Name', value: 'FullName' }
            }
              }
define root custom entity Zi_CE_CUSTOMER
{

      @UI.facet    : [{
           id      : 'Customer',
           purpose : #STANDARD,
           position: 1,
           label   : 'Customer',
           type    :  #IDENTIFICATION_REFERENCE
       }]

      @UI          : { lineItem: [
      { position: 10 },
  {
    type: #FOR_ACTION,
    dataAction: 'CreateCustomer',
    label: 'Create',
    position: 10
  }],
             identification: [{ position: 10 }],
             selectionField: [{ position: 10 }] }
  key CustomerID  : /dmo/customer_id;
      @UI          : { lineItem: [{ position: 20 }],
             identification: [{ position: 20 }],
             selectionField: [{ position: 20 }] }
      FirstName    : /dmo/first_name;

      @UI          : { lineItem: [{ position: 30 }],
             identification: [{ position: 30 }],
             selectionField: [{ position: 30 }] }
      LastName     : /dmo/last_name;

      @UI          : { lineItem: [{ position: 40 }],
             identification: [{ position: 40 }],
             selectionField: [{ position: 40 }] }
      Street       : /dmo/street;

      @UI          : { lineItem: [{ position: 50 }],
             identification: [{ position: 50 }],
             selectionField: [{ position: 50 }] }
      PostalCode   : /dmo/postal_code;

      @UI          : { lineItem: [{ position: 60 }],
             identification: [{ position: 60 }],
             selectionField: [{ position: 60 }] }
      City         : /dmo/city;

      @UI          : { lineItem: [{ position: 70 }],
             identification: [{ position: 70 }] }
      @EndUserText.label: 'Country'
      Country  : abap.char(50);

      @UI          : { lineItem: [{ position: 80 }],
             identification: [{ position: 80 }] }
      PhoneNumber  : /dmo/phone_number;

      @UI          : { lineItem: [{ position: 90 }],
             identification: [{ position: 90 }] }
      EmailAddress : /dmo/email_address;
      
      @UI          : { lineItem: [{ position: 100 }],
             identification: [{ position: 100 }] }
      @EndUserText.label: 'Customer Name'
      FullName     : abap.char(255);

}
