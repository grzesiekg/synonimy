use CGI qw/:standard/;
use Switch;
use DBI;

#stworzenie strony z formularzem wyboru operacji i polami do wpisywania wyrazów
print
	header(-charset=>'utf-8'),
	start_html('Synonimy'),
	h1('Synonimy'),
	start_form,
	"Wybierz operację",
	popup_menu(-name=>'operacja',
			-values=>['szukaj', 'dodaj','usuń']),p,
	"Wyraz główny ", textfield('wyraz1'),p,
	"Alternatywa", textfield('wyraz2'),p,
	submit('Wybierz'),
	defaults('Wyczyść'),
	end_form,
hr,"\n";

if (param)
{
#przypisanie wybranej operacji i wyrazów do zmiennych
	$x=param('operacja');
	$w1=param('wyraz1');
	$w2=param('wyraz2');
	$licznik=0;
#uruchomienie czynności w zależności od operacji
	switch($x)
	{
		case "szukaj" {
#ustanowienie połączenia z bazą danych, przygotowanie zapytania do wykonania w bazie
			$dbh = DBI->connect('dbi:mysql:grzesiekg','grzesiekg','perltest123')
			or die "Connection Error: $DBI::errstr\n";
			$dbh->{'mysql_enable_utf8'} = 1;
			$dbh->do('SET NAMES utf8');
			$sth = $dbh->prepare( "
		            SELECT wyraz1, wyraz2, wyraz3
		            FROM synonimy
		            WHERE wyraz1 = " . $dbh->quote( $w1 ) . "
				OR wyraz2 = " . $dbh->quote( $w1 ) . "
				OR wyraz3 = " . $dbh->quote( $w1 ) . "
			        " );
			$sth->execute
			or die "SQL Error: $DBI::errstr\n";
#wyświetlenie wyników zapytania lub informacji o ich braku
			while (@row = $sth->fetchrow_array) {
				print "@row \n";
				$licznik++;
			}
			if ($licznik==0)
			{
				print "Nie znaleziono wyrazu"
			} else
			{
				$licznik=0;
			}
			
		}
		case "dodaj" {print "dodaj"}
		case "usuń" {print "usuń"}
	}
}
print end_html;
