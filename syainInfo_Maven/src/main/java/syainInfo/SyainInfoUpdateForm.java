package syainInfo;

public class SyainInfoUpdateForm {
	//使用するデータに合わせて変数を用意（Dto）
	private int Id;
	private String SyainName;
	private int Age;
	private String Position;
	private String Tel;
	private String Skill;
	private String Hobby;
	private String Notes;

	public int getId() {
		return Id;
	}

	public String getSyainName() {
		return SyainName;
	}
	public int getAge() {
		return Age;
	}
	public String getPosition() {
		return Position;
	}
	public String getTel() {
		return Tel;
	}
	public String getSkill() {
		return Skill;
	}
	public String getHobby() {
		return Hobby;
	}
	public String getNotes() {
		return Notes;
	}

	public void setId(int id) {
		Id = id;
	}
	public void setSyainName(String syainName) {
		SyainName = syainName;
	}
	public void setAge(int age) {
		Age = age;
	}
	public void setPosition(String position) {
		Position = position;
	}
	public void setTel(String tel) {
		Tel = tel;
	}
	public void setSkill(String skill) {
		Skill = skill;
	}

	public void setHobby(String hobby) {
		Hobby = hobby;
	}

	public void setNotes(String notes) {
		Notes = notes;
	}

}
