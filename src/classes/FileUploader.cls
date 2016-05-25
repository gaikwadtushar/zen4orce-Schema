public class FileUploader 
{
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    String[] filecolumns = new String[]{};
    List<sObject> uploadedCSV;
    set<string> lstString ;
    List<string> lstMatchedColumns {get;set;}
    List<string> lstUnMatchedColumns {get;set;}
   	Map<string,Map<string,string>> mapCSV = new Map<string,Map<string,string>>();
    
    // Function to check CSV is blank or not
    public Boolean checkBlankCSV(){
    	nameFile=contentFile.toString();
        filelines = nameFile.split('\n');
        if(filelines.size()<2){
            return false;
        }
      return true;  	     
    }
    
    //  CSV into MAP<FieldNameAPI,map<ColumnName,RowValue>> Format 
    public map<string,map<string,string>> csvToMap(){
        Map<string,string> innerMap ;
        nameFile=contentFile.toString();
        filelines = nameFile.split('\n');
        filecolumns = filelines[0].split(',');
        for (Integer i=1;i<filelines.size();i++)
            {
                String[] inputvalues = new String[]{};
                inputvalues = filelines[i].split(',');
                lstString = new set<string>();
                innerMap = new Map<string,string>();
                for(Integer j=0;j<inputvalues.size();j++)
                {
                	lstString.add(filecolumns[j].replaceAll( '\\s+', ''));  
                	innerMap.put(filecolumns[j],inputvalues[j]);
                }
                mapCSV.put(inputvalues[2],innerMap); // remove this harcoding [2] this will come from custom metadata indexed 
            }
            return  mapCSV; 
    }
    
    // Match CSV column with CMT 
    public Boolean matchedColumnsCSVandCMT(set<string> defineCSVColumnNames){
    	lstMatchedColumns = new List<string>();
        lstUnMatchedColumns = new List<string>();
        for (String columns : lstString) {
    		if (defineCSVColumnNames.contains(columns)) {
        		lstMatchedColumns.add(columns);
    			} else {
        			lstUnMatchedColumns.add(columns);
    			}
			}         
        if(lstUnMatchedColumns.size()>0){
            return false;
        }
        return true;
    }
    
    
    public Pagereference ReadFile()
    {
    	string objName='CSVO__c';
    	 ApexPages.Message errormsg ;
        // check If CSV is Blank then no need go further return from here 
        if(checkBlankCSV()==false){
        	errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.Blank_CSV);
            ApexPages.addMessage(errormsg);
        	return null;
        }
 		// SET contains all Predeifuned columns in metadata 
        Set<string> defineCSVColumnNames = new set<string>();
        for(FieldTypeDetails__mdt ft : [select CSVColumnName__c from FieldTypeDetails__mdt]){	
        	defineCSVColumnNames.add(String.valueOf(ft.CSVColumnName__c));
        }
        // Map for Mandatory fields for field type
        Map<string,string> mapMandatoryFields = new Map<string,string>();
        for(MandatoryColumns_FiledTypeWise__mdt mf : [select MasterLabel,MandatoryFields__c from MandatoryColumns_FiledTypeWise__mdt ]){
        	mapMandatoryFields.put(mf.MasterLabel,mf.MandatoryFields__c);
        } 
        // Map for column name and their data type
 		Map<string,string> mapFieldDataType = new Map<string,string>();
        for(FieldTypeDetails__mdt ftDetails : [select CSVColumnName__c,DataType__c from FieldTypeDetails__mdt ]){
        	mapFieldDataType.put(ftDetails.CSVColumnName__c,ftDetails.DataType__c);
        }
        // Get CSV data into map in map<FieldAPIName,map<columnName,rowValue>> format 
        Map<string,map<string,string>> mapCSV = csvToMap();
        // Match CSV and custom metadata column names 
        if(matchedColumnsCSVandCMT(defineCSVColumnNames)==false){
        	errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.ColumnNameNotValid+lstUnMatchedColumns);
            ApexPages.addMessage(errormsg);
        	return null;
        }
        
     List<string> lstMandatoryColumnNotexist = new List<string>();
     Map<string,List<String>> mapMandatoryColumnNotexist = new Map<string,List<String>>();
     List<string> lstMandatoryColumnexist = new List<string>();
     String columnValue='';
     String mandFields='';
        for(String fieldApi : mapCSV.keySet()){   																			//System.debug('outer map value'+fieldApi);
        	Map<String, String> innerMap1 = mapCSV.get(fieldApi);
        	for(String innermapkey : mapCSV.get(fieldApi).keySet()){
        		if(innermapkey=='FieldType'){
        			columnValue  = mapCSV.get(fieldApi).get(innermapkey);
        				if(columnValue!=''){
        					mandFields = mapMandatoryFields.get(columnValue);
                 			if(mandFields!=null){
                 			    lstMandatoryColumnNotexist = new List<string>();
                 				mapMandatoryColumnNotexist = new Map<string,List<String>>();
                 				lstMandatoryColumnexist = new List<string>();
                 				for (String columns : mandFields.split(',')) {
    								if (lstString.contains(columns)) {
    									String datatype = mapFieldDataType.get(columns);
    									String value = innerMap1.get(columns);
    									if(datatype=='Number'){
    										try{
    											Integer iValue = Integer.valueOf(value);
    											} catch(Exception e){
    												errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.DataValidation+'columns '+'Data '+value );
            										ApexPages.addMessage(errormsg);
            										return null;
    											}
    									}
    									if(datatype=='Boolean'){
    										if(value.equalsIgnoreCase('true')||value.equalsIgnoreCase('false')||value.equalsIgnoreCase(''))
    										Boolean bValue = Boolean.valueOf(value) ;
    										else{
    											errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.DataValidation+'columns '+'Data '+value );
            									ApexPages.addMessage(errormsg);
            									return null;
    										}
    									}
    								}else{
        								lstMandatoryColumnNotexist.add(columns);
    								  }
								} 
                 			}
                 			if(lstMandatoryColumnNotexist.size()>0)
                 			mapMandatoryColumnNotexist.put(columnValue,lstMandatoryColumnNotexist);
                 			if(mapMandatoryColumnNotexist.size()>0)
                 			{
                 				errormsg = new ApexPages.Message(ApexPages.severity.ERROR,System.Label.MandatoryColumnNotExist+mapMandatoryColumnNotexist);
            									ApexPages.addMessage(errormsg);
            									return null;
                 			}
        			}	
        	}																	
        	 }
        }
       CustomSchemaBuilder.CSVData(mapCSV,objName);
        return null;    
}
            

}