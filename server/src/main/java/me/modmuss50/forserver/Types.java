package me.modmuss50.forserver;

import java.util.ArrayList;
import java.util.List;

public class Types {

	public static class DefaultResponse {
		public String status;
	}

	public static class ComputerData {
		public String name;
		public String id;
	}

	public static class Station extends ComputerData {

	}

	public static class Switch extends ComputerData  {
		String contiunesTo;
		String turnsTo;
	}

	public static class SwitchRequest   {
		Switch info;
		Minecart minecart;
	}

	public static class SwitchResponse extends DefaultResponse {
		boolean shouldSwitch;
	}

	public static class Minecart {
		String type;
		String name;
		String dest;
		String owner;
	}

	public static class ListRequest {
		String type;
		String ingoreId;
	}

	public static class ComputerList extends DefaultResponse {
		public List<ComputerData> computers = new ArrayList<>();
	}

}
