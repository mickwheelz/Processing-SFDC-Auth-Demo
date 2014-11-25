// import apache HTTP libraries
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.util.EntityUtils;
import org.apache.http.client.ClientProtocolException;

// declare salesforce login variables
static final String USERNAME = "mick.wheelz@gmail.com";
static final String PASSWORD = "InItial89ULi8HaMXOIx418iTkHK6gmTPT";
static final String LOGINURL = "https://login.salesforce.com";
static final String GRANTSERVICE ="/services/oauth2/token?grant_type=password";
static final String CLIENTID = "3MVG9Y6d_Btp4xp5LLJdvxJXv2qYyLbJtrC13AyKJVy1l9h9xq2eQzIGhC5IaQiCOnt0Btssf1NUL1BckOZad";
static final String CLIENTSECRET = "3875746611375330421";

// string for generated access token and URL
String accessToken;
String instanceURL;

public string loginSalesforce() {

  // build new httpclient
  HttpClient httpclient = HttpClientBuilder.create().build();
  
  //build login url string
  String loginURL = LOGINURL + GRANTSERVICE + "&client_id=" + CLIENTID + "&client_secret=" + CLIENTSECRET + "&username=" + USERNAME + "&password=" + PASSWORD;
  
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
  System.out.println("HTTP Status: " + statusCode);  
  
         
  try { // take JSON response from sfdc login, store access token and url to vars
      String jsonString = EntityUtils.toString(response.getEntity());
      JSONObject json;
      json = JSONObject.parse(jsonString);      
      System.out.println(json);
      accessToken = json.getString("access_token");
      instanceURL = json.getString("instance_url");
      System.out.println(accessToken);  
  } 
  
  catch (IOException ioException) {
    // put error handling code here
  }
 
   return accessToken;
 
 /*
  HttpGet httpgeter = new HttpGet(instanceURL + "/services/data/v29.0/query?q=SELECT+name+FROM+Product2" );
  httpgeter.setHeader("Authorization", "OAuth " + ACCESSTOKEN);
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
  
  System.out.println(getResult2);
*/

void setup () { 
  
}

}
