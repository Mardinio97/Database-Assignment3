package Model;

public class Donor {

    String name;
    String city;
    String email;
    String mobNumber;
    int groupBlood;

    public Donor( String name, String city, String email, String mobNumber, int groupBlood) {

        this.name = name;
        this.city = city;
        this.email = email;
        this.mobNumber = mobNumber;
        this.groupBlood = groupBlood;
    }

    public String getName() {
        return name;
    }

    public String getCity() {
        return city;
    }

    public String getEmail() {
        return email;
    }

    public String getMobNumber() {
        return mobNumber;
    }

    public int getGroupBlood() {
        return groupBlood;
    }
}
