<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.nio.file.Path"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.util.List"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.Scanner"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%!
private static HashMap<String, List<String>> buildWordMapping(List<String> lines){
	//Create a map of the first word to the related
	HashMap<String, List<String>> wordMap = new HashMap<String,List<String>>();
	for(int i = 0; i < lines.size(); i++){
		String line = lines.get(i);
		int index = line.indexOf(",");
		if(index > 0){
			String key = line.substring(0, index);
			String[] values = line.substring(index+1, line.length()).split(",");
			wordMap.put(key, Arrays.asList(values));
		}		
	}
	
	return wordMap;
}

private static List<String> search(String term, HashMap<String, List<String>> wordMap, String limitCount){
	List<String> result = new ArrayList<String>();	
	if(!term.isEmpty()){
		result = wordMap.get(term);
		result = result == null ? wordMap.get(term.toLowerCase()) : result;
		//TODO: add union with thesaurus
		
		// No Results Found Return Empty
		result = result == null ? new ArrayList<String>() : result;
	}
	
	Integer limit = limitCount == null ? result.size() : Integer.parseInt(limitCount);
	limit = limit > result.size() ? result.size() : limit;
	return result.subList(0, limit);
}
%>
<%
try{
String filePath = request.getServletContext().getRealPath("/resources/words.txt");
List<String> lines = Files.readAllLines(Paths.get(filePath));
HashMap<String, List<String>> wordMap = buildWordMapping(lines);
String term = request.getParameter("term");
String limitCount = request.getParameter("limit");
Gson gson = new Gson();
JsonObject results = new JsonObject();
if(term == null){
	results.addProperty("results", "");	
}else{	
	List<String> searchResults = search(term, wordMap, limitCount);
	results.addProperty("values", gson.toJson(searchResults));	
}

out.println(new Gson().toJson(results));
}catch(Exception ex){
	out.println(ex.getMessage());
}
%>