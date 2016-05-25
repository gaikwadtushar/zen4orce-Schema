public class FileUploaderTest {
	public static testMethod void testBlanKCSV()
	{
		FileUploader fileuploaderobj = new FileUploader();
		String dataCSV = 'FieldType,FieldName,FieldApiName,Required,Percision,Scale,DefaultValue,Description,InlineHelpText,PickListValues,VisibleLines,ExternalId,Unique,Sorted,RelationShipName,ReferenceTo\n';
		fileuploaderobj.contentFile = Blob.valueOf(dataCSV);//NEED TO CONVERT STRING TO BLOB
		fileuploaderobj.ReadFile();
		
	}
    public static testMethod void testHeaderValues()
	{
		FileUploader fileuploaderobj = new FileUploader();
		String dataCSV = 'FieldType,FieldName,FieldApi,Required,Percision,DefaultValue,Description,InlineHelpText,PickListValues,VisibleLines,ExternalId,Unique,Sorted,RelationShipName,ReferenceTo\n'+
		'Text,EmpName,EmpName__c,TRUE,,,,,,,,,,,,\n'+
		'Number,EmpSalary,EmpSalary__c,TRUE,10,2,,,,,,,,,,\n';
		fileuploaderobj.contentFile = Blob.valueOf(dataCSV);//NEED TO CONVERT STRING TO BLOB
		fileuploaderobj.ReadFile();
		
	}
    public static testMethod void testHeaderVal()
	{
		FileUploader fileuploaderobj = new FileUploader();
		String dataCSV = 'FieldType,FieldName,FieldApiName,Required,Percision,Scale,DefaultValue,Description,InlineHelpText,PickListValues,VisibleLines,ExternalId,Unique,Sorted,RelationShipName,ReferenceTo\n'+
		'Text,EmpName,EmpName__c,TRUE,,,,,,,,,,,,\n'+
		'Number,EmpSalary,EmpSalary__c,TRUE,10,2,,,,,,,,,,\n';
		
		fileuploaderobj.contentFile = Blob.valueOf(dataCSV);//NEED TO CONVERT STRING TO BLOB
		fileuploaderobj.ReadFile();
		
	}
    public static testMethod void testDataVal()
	{
		FileUploader fileuploaderobj = new FileUploader();
		String dataCSV = 'FieldType,FieldName,FieldApiName,Required,Percision,Scale,DefaultValue,Description,InlineHelpText,PickListValues,VisibleLines,ExternalId,Unique,Sorted,RelationShipName,ReferenceTo\n'+
		'Text,EmpName,EmpName__c,work,,,,,,,,,,,,\n'+
		'Number,EmpSalary,EmpSalary__c,TRUE,abc,2,,,,,,,,,,\n';
		
		fileuploaderobj.contentFile = Blob.valueOf(dataCSV);
		fileuploaderobj.ReadFile();
		
	}
        public static testMethod void testNumVal()
	{
		FileUploader fileuploaderobj = new FileUploader();
		String dataCSV = 'FieldType,FieldName,FieldApiName,Required,Percision,Scale,DefaultValue,Description,InlineHelpText,PickListValues,VisibleLines,ExternalId,Unique,Sorted,RelationShipName,ReferenceTo\n'+
		'Number,EmpSalary,EmpSalary__c,TRUE,abc,2,,,,,,,,,,\n';
		
		fileuploaderobj.contentFile = Blob.valueOf(dataCSV);
		fileuploaderobj.ReadFile();
		
	}
          public static testMethod void testallVal()
	{
		FileUploader fileuploaderobj = new FileUploader();
		String dataCSV = 'FieldType,FieldName,FieldApiName,Required,Percision,Scale,DefaultValue,Description,InlineHelpText,PickListValues,VisibleLines,ExternalId,Unique,Sorted,RelationShipName,ReferenceTo\n'+
		'Number,EmpSalary,EmpSalary__c,TRUE,20,2,,,,,,,,,,\n';
		
		fileuploaderobj.contentFile = Blob.valueOf(dataCSV);
		fileuploaderobj.ReadFile();
		
	}
}