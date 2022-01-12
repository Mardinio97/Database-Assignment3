
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.Reader;
import java.sql.Connection;
import java.sql.DriverManager;

import org.apache.ibatis.jdbc.ScriptRunner;
public class Main {

    public static void main(String args[]) throws Exception {

        String mysqlUrl = "jdbc:mysql://localhost:3306/blood_donation";
        Connection con = DriverManager.getConnection(mysqlUrl, "root", "root");

        System.out.println("Connection established......");
        System.out.println("Preparing Database....");


        /*ScriptRunner sr = new ScriptRunner(con);

        Reader reader = new BufferedReader(new FileReader("src/kalili_Nima_3.sql"));

        sr.runScript(reader);*/




          Dashboard.runDashboard();

    }
}