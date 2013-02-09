use CGI qw/:standard/;

#stworzenie strony z formularzem wyboru operacji
print
	header(-charset=>'utf-8'),
	start_html('Synonimy'),
	h1('Synonimy'),
	start_form,
	"Wybierz operację",
	popup_menu(-name=>'operacja',
			-values=>['szukaj', 'dodaj','usuń']),p,
	submit('Wybierz'),
	defaults('Wyczyść'),
	end_form,
hr,"\n";

if (param)
{
	print "done";
}
print end_html;
