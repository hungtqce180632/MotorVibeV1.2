/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package GoogleClass;

import ConstantGG.Iconstant1;
import ConstantGG.Iconstant2;
import Models.GoogleAccount;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

/**
 *
 * @author thaii
 */
public class GoogleLogin {

    private static String accessToken = "";
    private static GoogleAccount googlePojo = null;

    public static String getToken(String code, String type) throws ClientProtocolException, IOException {
        if (type.equals("login")) {
            String response = Request.Post(Iconstant1.GOOGLE_LINK_GET_TOKEN)
                    .bodyForm(
                            Form.form()
                                    .add("client_id", Iconstant1.GOOGLE_CLIENT_ID)
                                    .add("client_secret", Iconstant1.GOOGLE_CLIENT_SECRET)
                                    .add("redirect_uri", Iconstant1.GOOGLE_REDIRECT_URI)
                                    .add("code", code)
                                    .add("grant_type", Iconstant1.GOOGLE_GRANT_TYPE)
                                    .build()
                    )
                    .execute().returnContent().asString();

            JsonObject jobj = new Gson().fromJson(response, JsonObject.class);

            accessToken = jobj.get("access_token").toString().replaceAll("\"", "");
        }

        if (type.equals("signup")) {
            String response = Request.Post(Iconstant2.GOOGLE_LINK_GET_TOKEN)
                    .bodyForm(
                            Form.form()
                                    .add("client_id", Iconstant2.GOOGLE_CLIENT_ID)
                                    .add("client_secret", Iconstant2.GOOGLE_CLIENT_SECRET)
                                    .add("redirect_uri", Iconstant2.GOOGLE_REDIRECT_URI)
                                    .add("code", code)
                                    .add("grant_type", Iconstant2.GOOGLE_GRANT_TYPE)
                                    .build()
                    )
                    .execute().returnContent().asString();

            JsonObject jobj = new Gson().fromJson(response, JsonObject.class);

            accessToken = jobj.get("access_token").toString().replaceAll("\"", "");
        }

        return accessToken;
    }

    public static GoogleAccount getUserInfo(final String accessToken, String type) throws ClientProtocolException, IOException {
        if (type.equals("signup")) {
            String link = Iconstant2.GOOGLE_LINK_GET_USER_INFO + accessToken;

            String response = Request.Get(link).execute().returnContent().asString();

            googlePojo = new Gson().fromJson(response, GoogleAccount.class);
        }
        
        if (type.equals("login")) {
            String link = Iconstant1.GOOGLE_LINK_GET_USER_INFO + accessToken;

            String response = Request.Get(link).execute().returnContent().asString();

            googlePojo = new Gson().fromJson(response, GoogleAccount.class);
        }

        return googlePojo;

    }
}
