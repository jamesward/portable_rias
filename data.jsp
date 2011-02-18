<list>

<%
String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov"};

for (int i = 6; i < 8; i++)
{
  for (int j = 0; j < months.length; j++)
  {
    String month = months[j] + "-0" + i;
    int apacRev = (int)(Math.random() * 60000);
    int europeRev = (int)(Math.random() * 80000);
    int japanRev = (int)(Math.random() * 50000);
    int latinAmRev = (int)(Math.random() * 30000);
    int northAmRev = (int)(Math.random() * 100000);
    int totalRev = apacRev + europeRev + japanRev + latinAmRev + northAmRev;
    int averageRev = totalRev / 6;
%>

    <month name="<%=month%>" revenue="<%=totalRev%>" average="<%=averageRev%>">
        <region name="APAC" revenue="<%=apacRev%>"/>
        <region name="Europe" revenue="<%=europeRev%>"/>
        <region name="Japan" revenue="<%=japanRev%>"/>
        <region name="Latin America" revenue="<%=latinAmRev%>"/>
        <region name="North America" revenue="<%=northAmRev%>"/>
    </month>

<%
  }
}
%>

</list>
