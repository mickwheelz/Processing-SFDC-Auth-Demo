// import apache HTTP libraries
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.util.EntityUtils;
import org.apache.http.client.ClientProtocolException;

public String[] loginSalesforce(String username, String password, String url, String grantService, String clientId, String clientSecret) {
  
  //string for output of token and url
  String[] accessDetails = new String[2];

  // build new httpclient
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

String readProducts( String[] accessDetails ) {
  
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

}

Boolean insertSlide( String[] accessDetails, String[] rideDetails) {
  
  Boolean isSuccess = false;
  JSONObject ride;
  
  HttpClient httpclient = HttpClientBuilder.create().build();
   
  ride = new JSONObject();

  ride.setString("Barcode__c", rideDetails[0]);
  ride.setFloat("ET__c", Float.valueOf(rideDetails[1]));
  ride.setFloat("Reaction_Time__c", Float.valueOf(rideDetails[1]));
  ride.setFloat("Sector_1__c", Float.valueOf(rideDetails[2]));
  ride.setFloat("Sector_2__c", Float.valueOf(rideDetails[3]));
  ride.setFloat("Sector_3__c", Float.valueOf(rideDetails[4]));
  ride.setFloat("Sector_4__c", Float.valueOf(rideDetails[5]));
  ride.setFloat("Speed__c", Float.valueOf(rideDetails[6]));
  ride.setFloat("Total_Time__c", Float.valueOf(rideDetails[7]));
 
  HttpPost post = new HttpPost(accessDetails[1] + "/services/data/v29.0/sobjects/Slide_Run__c/");
  post.setHeader("Authorization", "OAuth " + accessDetails[0]);
  post.addHeader("Content-Type", "application/json");

  try {
  StringEntity params = new StringEntity(ride.toString());
    post.setEntity( params );
    System.out.println(ride);
  }
  
  catch(Exception uee) {
    uee.printStackTrace();
  }
 
  try {
    HttpResponse response = httpclient.execute(post);
    System.out.println(response);
 // httpclient.execute(post);
  isSuccess = true;  
  }
  
  catch (IOException ie) {
   isSuccess = false; 
  }
   
  return isSuccess;
  
}

void setup () { 
  
  String username = "mick.wheelz@gmail.com";
  String password = "InItial89ULi8HaMXOIx418iTkHK6gmTPT";
  String url = "https://login.salesforce.com";
  String grantService ="/services/oauth2/token?grant_type=password";
  String clientId = "3MVG9Y6d_Btp4xp5LLJdvxJXv2qYyLbJtrC13AyKJVy1l9h9xq2eQzIGhC5IaQiCOnt0Btssf1NUL1BckOZad";
  String clientSecret = "3875746611375330421";
  
  String[] testData = new String[8];
  
  testData[0] = "005";
  testData[1] = "10.10";
  testData[2] = "10.10";
  testData[3] = "10.10";   
  testData[4] = "10.10";
  testData[5] = "10.10";
  testData[6] = "10.10";
  testData[7] = "10.10";
 
  int t = millis();
  String[] accessDetails = loginSalesforce(username, password, url, grantService, clientId, clientSecret);
  int r = millis() - t;
  
//int x = millis();
//String productResult = readProducts(accessDetails);
//int y = millis() - x;
  
  
  int x = millis();
  Boolean insertSlideResult = insertSlide(accessDetails, testData);
  int y = millis() - x;
  
  System.out.println(accessDetails[0]);
  System.out.println("Login Time: " + r);

//System.out.println(productResult);  
//System.out.println("List Product Time: " + y);
  
  System.out.println("Insert Success: " + insertSlideResult);
  System.out.println("Insert Time: " + y);

}


