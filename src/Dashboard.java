import Model.Donor;

import javax.swing.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.Scanner;

public class Dashboard {
    private static CallableStatement stmt; //CallableStatement interface is used to call the stored procedures and functions.
    private static String query;
    private static Statement st;
    private static ResultSet rs;

    public static int getChoiceIndex(final Object choice, final Object[] choices) {
        if (choice != null) {
            for (int i = 0; i < choices.length; i++) {
                if (choice.equals(choices[i])) {
                    return i;
                    //this method is used to return the index of the array for the (String[] choices)
                    //like if the user choose the first choice then its conisderd to be index 0
                }
            }
        }
        return -1;
    }

    public static void check(int object) {
//checks that the input is not null and to make sure that the user inserted something
        if (object == -1) {
            System.exit(0);
        }


    }
    private static boolean empty(String input){
        boolean isempty = false;
        if (input == null || input.isEmpty()) {
            isempty = true;

        }
        return isempty;
    }

    public static void runDashboard() throws SQLException {
        Connection conn = null;
        Object input = null;
        while (true) {
            String mysqlUrl = "jdbc:mysql://localhost/blood_donation"; //we connect to the databse through this mysqlUrl path
            conn = DriverManager.getConnection(mysqlUrl, "root", "root");
            String[] choices = {"Register a donor", "Register a donation", "Register a transfusion", "Check total donations received for a specific donor", "Check a transfusion", "Check total donations received", "EXIT"};
            //these are the choices which pops up in the welcoming window
            input = JOptionPane.showInputDialog(null, "Choose now...",
                    "The Choice of a Lifetime", JOptionPane.QUESTION_MESSAGE, null, // Use

                    choices,
                    choices[0]);


            Scanner scanner = new Scanner(System.in);
            int userInput = getChoiceIndex(input, choices);
            check(userInput);

            ArrayList<String> arrayList = new ArrayList<>();
            //this arrayList  is for saving the data from then user

            switch (userInput) {

                case 0:
                    try {

                        String name = JOptionPane.showInputDialog("Please Enter Donor's name: ");
                        arrayList.add(name);
                        if (empty(name)) { //check that the user has inserted an input.
                            JFrame f;
                            f = new JFrame();
                            JOptionPane.showMessageDialog(f, "Field Can Not Be Empty", "Alert", JOptionPane.WARNING_MESSAGE);
                            runDashboard(); //the main meny will pop up again and ask the user to re-enter the data again
                        }

                        name = JOptionPane.showInputDialog("Please Enter Donor's city: ");
                        arrayList.add(name);
                        if (empty(name)) {
                            JFrame f;
                            f = new JFrame();
                            JOptionPane.showMessageDialog(f, "Field Can Not Be Empty", "Alert", JOptionPane.WARNING_MESSAGE);
                            runDashboard();
                        }

                        name = JOptionPane.showInputDialog("Please Enter Donor's email: ");
                        arrayList.add(name);
                        if (empty(name)) {
                            JFrame f;
                            f = new JFrame();
                            JOptionPane.showMessageDialog(f, "Field Can Not Be Empty", "Alert", JOptionPane.WARNING_MESSAGE);
                            runDashboard();
                        }
                        name = JOptionPane.showInputDialog("Please Enter Donor's Mobile Number: ");
                        arrayList.add(name);
                        if (empty(name)) {
                            JFrame f;
                            f = new JFrame();
                            JOptionPane.showMessageDialog(f, "Field Can Not Be Empty", "Alert", JOptionPane.WARNING_MESSAGE);
                            runDashboard();
                        }
                        String[] choicesGroup = {"A", "B", "AB", "O"};
                         //array for the blood group ( blood type)
                        input = JOptionPane.showInputDialog(null, "Donor's Blood Group: ",
                                "Blood Group:", JOptionPane.DEFAULT_OPTION, null, // Use

                                choicesGroup,
                                choicesGroup[0]);



                        int bloodGroup = getChoiceIndex(input, choicesGroup);
                        arrayList.add(String.valueOf(bloodGroup));

                        query = "{CALL add_donor(?,?,?,?,?)}";

                        Donor donor = new Donor(arrayList.get(0), arrayList.get(1), arrayList.get(2), arrayList.get(3), (Integer.parseInt(arrayList.get(4)) + 1));
                        stmt = conn.prepareCall(query); // its is used to store the procedure that recieves the  query which in our case is ( name ,city email, number ,groupblood)


                        stmt.setString(1, donor.getName());
                        stmt.setString(2, donor.getCity());
                        stmt.setString(3, donor.getEmail());
                        stmt.setString(4, donor.getMobNumber());
                        stmt.setInt(5, donor.getGroupBlood());


                        rs = stmt.executeQuery(); // this method is used to excute the statment , in other words to retrive the data
                        while (rs.next()) {
                            JFrame f = new JFrame();
                            JOptionPane.showMessageDialog(f, "DONOR ID: " + rs.getInt("donorID") + "\n" + "Please give this ID to the Donor to use it the next time");


                        }
                        conn.close();

                    } catch (Exception e) {
                        System.err.println("Got an exception!");
                        System.err.println(e.getMessage());
                    }
                    break;
                case 1:

                    String mob_number = JOptionPane.showInputDialog("Please Enter Donor's Mobile Number: ");
                    if (empty(mob_number)) {
                        JFrame f;
                        f = new JFrame();
                        JOptionPane.showMessageDialog(f, "Field Can Not Be Empty", "Alert", JOptionPane.WARNING_MESSAGE);
                        runDashboard();
                    }
                    int amount = Integer.parseInt(JOptionPane.showInputDialog("Please Enter Donor's Mobile Number: "));

                    if (empty(String.valueOf(amount)) ) {
                        JFrame f;
                        f = new JFrame();
                        JOptionPane.showMessageDialog(f, "Field Can Not Be Empty", "Alert", JOptionPane.WARNING_MESSAGE);
                        runDashboard();
                    }
                    String[] choicesGroup = {"The Donation still under Processing", "The Donation Has Been Sent", "The Donation Has Been Sent And Arrived At The Clinic", "The Donation Has Been Sent And Arrived At The Clinic"};

                    final Object input2 = JOptionPane.showInputDialog(null, "Donation Status",
                            "Status:", JOptionPane.DEFAULT_OPTION, null, // Use

                            choicesGroup,
                            choicesGroup[0]);



                    int stat = getChoiceIndex(input2, choicesGroup);
                    query = "{CALL add_donation(?,?,?)}";
                    stmt = conn.prepareCall(query);
                    stmt.setString(1, mob_number);
                    stmt.setInt(2, amount);
                    stmt.setInt(3, (stat +1));
                    stmt.executeQuery();


                    break;
                case 2:

                    int donationsN = Integer.parseInt(JOptionPane.showInputDialog("Please Enter The Donation's Number"));

                    if (empty(String.valueOf(donationsN)) ) {
                        JFrame f;
                        f = new JFrame();
                        JOptionPane.showMessageDialog(f, "Field Can Not Be Empty", "Alert", JOptionPane.WARNING_MESSAGE);
                        runDashboard();
                    }
                    query = "{CALL add_transfusion(?)}";
                    stmt = conn.prepareCall(query);
                    stmt.setInt(1, donationsN);
                    rs = stmt.executeQuery();
                    while (rs.next()) {
                        JFrame f = new JFrame();
                        JOptionPane.showMessageDialog(f, "The receiver's personal number is: " + rs.getBigDecimal("reciver_rand"));

                    }
                    break;


                case 3:

                    String mNumber = JOptionPane.showInputDialog("Please Enter Donor's Mobile Number: ");
                    if (mNumber == null) {
                        JFrame f;
                        f = new JFrame();
                        JOptionPane.showMessageDialog(f, "Field Can Not Be Empty", "Alert", JOptionPane.WARNING_MESSAGE);
                        runDashboard();
                    }
                    query = "{CALL check_donations_for_user(?)}";
                    stmt = conn.prepareCall(query);
                    stmt.setString(1, String.valueOf(mNumber));
                    rs = stmt.executeQuery();
                    while (rs.next()) {
                        JFrame f = new JFrame();
                        JOptionPane.showMessageDialog(f, "NAME: " + rs.getString("name") + "\n" + "CITY: " + rs.getString("city") + "\n" + "BLOOD GROUP: " + rs.getString("blood_group") + "\n" + "NUMBER OF DONATIONS: " + rs.getInt("number_of_donations") + "\n");
                    }
                    break;
                case 4:

                    int id = Integer.parseInt(JOptionPane.showInputDialog("Please Enter the transfusion ID"));
                    if (empty(String.valueOf(id)) ) {
                        JFrame f;
                        f = new JFrame();
                        JOptionPane.showMessageDialog(f, "Field Can Not Be Empty", "Alert", JOptionPane.WARNING_MESSAGE);
                        runDashboard();
                    }
                    String a = "select donor_id, name,mob_number,blood_group,t.transfusion_id,t.receiver_id,t.transfusion_Bag_Id,bd.donation_number\n" +
                            "from donor join transfusion t on donor.donor_id = t.blood_donor_id\n" +
                            "    join blood_donation bd on t.transfusion_Bag_Id = bd.blood_Bag_Id\n" +
                            "join transfusion t2 on donor.donor_id = t2.blood_donor_id\n" +
                            "where t2.transfusion_id = " + id;

                    st = conn.createStatement();


                    rs = st.executeQuery(a);
                    while (rs.next()) {
                        int rs_id = rs.getInt("donor_id");
                        String rs_firstName = rs.getString("name");
                        String rs_NUMBER = rs.getString("mob_number");
                        String bloodGroup = rs.getString("blood_group");
                        JFrame f = new JFrame();
                        JOptionPane.showMessageDialog(f, "ID: " + rs_id + "\n" + "NAME: " + rs_firstName + "\n" + "NUMBER: " + rs_NUMBER + "\n" + "BLOOD GROUP: " + bloodGroup + "\n");

                    }
                    st.close();


                    break;
                case 5:
                    query = "select * from total_donations;";
                    st = conn.createStatement();


                    ResultSet ras = st.executeQuery(query);
                    while (ras.next()) {
                        JFrame f = new JFrame();
                        JOptionPane.showMessageDialog(f, "Total Donations: " + ras.getInt("count"));


                    }
                    break;
                case 6:

                    return;
                case -1:
                    System.exit(0);
                    return;
            }


        }


    }
}
