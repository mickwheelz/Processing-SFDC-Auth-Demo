// import apache HTTP libraries
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.util.EntityUtils;
import org.apache.http.client.ClientProtocolException;

public String[] loginSalesforce(String[] salesforceLogin) {
 
  // split array into strings to pass to httpclient
  String username = salesforceLogin[0];
  String password = salesforceLogin[1];
  String url = salesforceLogin[2];
  String grantService = salesforceLogin[3];
  String clientId = salesforceLogin[4];
  String clientSecret = salesforceLogin[5];
  
  //string for output of token and url
  String[] accessDetails = new String[2];

  // build new httpclient change here
  HttpClient httpclient = HttpClientBuilder.create().build();
  
  //build login url string
  String loginURL = url + grantService + "&client_id=" + clientId + "&client_secret=" + clientSecret + "&username=" + username + "&password=" + password;
  
  // setup post request
  HttpPost httpPost = new HttpPost(loginURL);
  HttpResponse response = null;
  
  try { // do salesforce login
  response = httpclient.execute(httpPost);
  } 
  
  catch (ClientProtocolException cpException) {
    // put error handling code here
  } 
  
  catch (IOException ioException) {
    // put error handling code here
  }
  
  // get http status code, output to console
  int statusCode = response.getStatusLine().getStatusCode();
  //System.out.println("HTTP Status: " + statusCode);  
  
         
  try { // take JSON response from sfdc login, store access token and url to vars
      String jsonString = EntityUtils.toString(response.getEntity());
      JSONObject json;
      json = JSONObject.parse(jsonString);      
      //System.out.println(json);
      accessDetails[0] = json.getString("access_token");
      accessDetails[1] = json.getString("instance_url");
      //System.out.println(accessToken);  
  } 
  
  catch (IOException ioException) {
    // put error handling code here
  }
   // return access token and url to class
   return accessDetails;
}

/* String readProducts( String[] accessDetails ) {
  
  HttpClient httpclient = HttpClientBuilder.create().build();

  HttpGet httpgeter = new HttpGet(accessDetails[1] + "/services/data/v29.0/query?q=SELECT+name+FROM+Product2" );
  httpgeter.setHeader("Authorization", "OAuth " + accessDetails[0]);
  HttpResponse getresponse = null;
          
  try {          
    getresponse = httpclient.execute(httpgeter);
  } 
  catch (ClientProtocolException cpException) {
    // put error handling code here
  }
  catch (IOException ioException) {
    // put error handling code here
  }  
  
  String getResult2 = null;
  
  try {
    getResult2 = EntityUtils.toString(getresponse.getEntity());
   } 
  catch (IOException ioException) {
    // put error handling code here
  }
  
  return getResult2;

} */

Boolean insertSlide( String[] accessDetails, JSONObject rideDetails) {
  
  Boolean isSuccess = false;
  
  HttpClient httpclient = HttpClientBuilder.create().build();
   
  HttpPost post = new HttpPost(accessDetails[1] + "/services/data/v29.0/sobjects/Slide_Run__c/");
  post.setHeader("Authorization", "OAuth " + accessDetails[0]);
  post.addHeader("Content-Type", "application/json");

  try {
  StringEntity params = new StringEntity(rideDetails.toString());
    post.setEntity( params );
  }
  
  catch(Exception uee) {
    uee.printStackTrace();
  }
 
  try {
    HttpResponse response = httpclient.execute(post);
    if ( response.getStatusLine().getStatusCode() == 201 ) {
      isSuccess = true;
    }
    else {
      isSuccess = false;
    }
    
  }
  
  catch (IOException ie) {
   isSuccess = false; 
  }
   
  return isSuccess;
  
}

void setup () { 
  
  String[] salesforceLoginDetails = new String[6];
  
  salesforceLoginDetails[0] = "username@domain.com"; //username
  salesforceLoginDetails[1] = "passwordtoken"; //password and token
  salesforceLoginDetails[2] = "https://login.salesforce.com"; //login url
  salesforceLoginDetails[3] ="/services/oauth2/token?grant_type=password"; // grant type
  salesforceLoginDetails[4] = "id"; //client id
  salesforceLoginDetails[5] = "secret"; //client secret
  
  JSONObject rideTest;
    
  rideTest = new JSONObject();

  rideTest.setString("Barcode__c", "005");
  rideTest.setFloat("ET__c", 10.10 );
  rideTest.setFloat("Reaction_Time__c", 10.10);
  rideTest.setFloat("Sector_1__c", 10.10);
  rideTest.setFloat("Sector_2__c", 10.10 );
  rideTest.setFloat("Sector_3__c", 10.10 );
  rideTest.setFloat("Sector_4__c", 10.10 );
  rideTest.setFloat("Speed__c", 10.10 );
  rideTest.setFloat("Total_Time__c", 10.10 );
 
  int t = millis();
  String[] accessDetails = loginSalesforce(salesforceLoginDetails);
  int r = millis() - t;
  
//int x = millis();
//String productResult = readProducts(accessDetails);
//int y = millis() - x;
  
  
  int x = millis();
  Boolean insertSlideResult = insertSlide(accessDetails, rideTest);
  int y = millis() - x;
  
  System.out.println("Token: " + accessDetails[0]);
  System.out.println("Login Time: " + r);

//System.out.println(productResult);  
//System.out.println("List Product Time: " + y);
  
  System.out.println("Insert Success: " + insertSlideResult);
  System.out.println("Insert Time: " + y);

}


