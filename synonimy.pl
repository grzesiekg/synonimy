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

#uruchomienie czynności w zależności od wybranej operacji
	switch($x)
	{
		case "szukaj" {
			if ($w1)
			{
#ustanowienie połączenia z bazą danych, przygotowanie zapytania do wykonania w bazie
				$dbh = DBI->connect('dbi:mysql:grzesiekg','grzesiekg','perltest123')
				or die "Connection Error: $DBI::errstr\n";
				$dbh->{'mysql_enable_utf8'} = 1;
				$dbh->do('SET NAMES utf8');
				$sth = $dbh->prepare( "
			            SELECT wyraz1, wyraz2, wyraz3
			            FROM synonimy
			            WHERE wyraz1 = '$w1'
					OR wyraz2 = '$w1'
					OR wyraz3 = '$w1'
				        " );
				$sth->execute
				or die "SQL Error: $DBI::errstr\n";
#wyświetlenie wyników zapytania lub informacji o ich braku
				while (@row = $sth->fetchrow_array) {
					print "@row \n";
				}
				if ($sth->rows == 0)
				{
					print "Nie znaleziono wyrazu";
				}
				$sth->finish;
				$dbh->disconnect();
			}else
			{
				print "Nie podałeś wyrazu";
			}
		}
		case "dodaj" {
#sprawdzenie czy wyraz1 jest w bazie i pobranie wiersza w którym się znajduje
			if ($w1)
			{
				$dbh = DBI->connect('dbi:mysql:grzesiekg','grzesiekg','perltest123')
				or die "Connection Error: $DBI::errstr\n";
				$dbh->{'mysql_enable_utf8'} = 1;
				$dbh->do('SET NAMES utf8');
				$sth = $dbh->prepare( "
			            SELECT *
			            FROM synonimy
			            WHERE wyraz1 = '$w1'
					OR wyraz2 = '$w1'
					OR wyraz3 = '$w1'
				        " );
				$sth->execute
				or die "SQL Error: $DBI::errstr\n";
				@row1 = $sth->fetchrow_array;
				if ($sth->rows == 0)
				{$id1=0;}else
				{$id1=$row1[0];}
			}else
			{$id1=0;}
#sprawdzenie czy wyraz2 jest w bazie i pobranie wiersza w ktorym sie znajduje
			if ($w2)
			{
				$dbh = DBI->connect('dbi:mysql:grzesiekg','grzesiekg','perltest123')
				or die "Connection Error: $DBI::errstr\n";
				$dbh->{'mysql_enable_utf8'} = 1;
				$dbh->do('SET NAMES utf8');
				$sth = $dbh->prepare( "
			            SELECT *
			            FROM synonimy
			            WHERE wyraz1 = '$w2'
					OR wyraz2 = '$w2'
					OR wyraz3 = '$w2'
				        " );
				$sth->execute
				or die "SQL Error: $DBI::errstr\n";
				@row2 = $sth->fetchrow_array;
				if ($sth->rows == 0)
				{$id2=0;}else
				{$id2=$row2[0];}
			}else
			{$id2=0}
#jeżeli oba wyrazy są w bazie to nie dodajemy
			if (($id1>0 && $id2>0) || ($id1>0 && !$w2) || ($id2>0 && !$w1))
			{
				print "Wyrazy są już w bazie";
				$sth->finish;
				$dbh->disconnect();
			}
#jeżeli obu wyrazów nie ma to dodajemy nowy rekord			
			elsif ($id1==0 && $id2==0)
			{
				$sth = $dbh->prepare("
					INSERT INTO synonimy (wyraz1, wyraz2)
					VALUES ('$w1', '$w2')
					");
				$sth->execute
				or die "SQL Error: $DBI::errstr\n";
				$sth->finish;
				$dbh->disconnect();
				print "Wyrazy dodane"
			}
#jeżeli jest jeden wyraz to dodajemy do niego drugi, jeżeli jest jeszcze miejsce			
			else
			{
				if ($id1)
				{
					if ($row1[3])
					{
						print "Nie ma miejsca na dodanie wyrazu: $w2";
					}elsif (!$row1[2])
					{
						$dbh->do("UPDATE synonimy SET wyraz2='$w2' WHERE id=$id1");
						$sth->finish;
						$dbh->disconnect();
						print "Wyraz dodany: $w2";
					}else
					{
						$dbh->do("UPDATE synonimy SET wyraz3='$w2' WHERE id=$id1");
						$sth->finish;
						$dbh->disconnect();
						print "Wyraz dodany: $w2";
					}
				}else
				{
					if ($row2[3])
					{
						print "Nie ma miejsca na dodanie wyrazu: $w1";
					}elsif (!$row2[2])
					{
						$dbh->do("UPDATE synonimy SET wyraz2='$w1' WHERE id=$id2");
						$sth->finish;
						$dbh->disconnect();
						print "Wyraz dodany: $w1";
					}else
					{
						$dbh->do("UPDATE synonimy SET wyraz3='$w1' WHERE id=$id2");
						$sth->finish;
						$dbh->disconnect();
						print "Wyraz dodany: $w1";
					}
				}
			}	
		}
		case "usuń" {print "usuń";
			if ($w1)
			{
#ustanowienie połączenia z bazą danych, przygotowanie zapytania do wykonania w bazie
				$dbh = DBI->connect('dbi:mysql:grzesiekg','grzesiekg','perltest123')
				or die "Connection Error: $DBI::errstr\n";
				$dbh->{'mysql_enable_utf8'} = 1;
				$dbh->do('SET NAMES utf8');
				$sth = $dbh->prepare( "
			            SELECT *
			            FROM synonimy
			            WHERE wyraz1 = '$w1'
					OR wyraz2 = '$w1'
					OR wyraz3 = '$w1'
				        " );
				$sth->execute
				or die "SQL Error: $DBI::errstr\n";
				@row = $sth->fetchrow_array;
				if ($sth->rows == 0)
				{
					print "Nie znaleziono wyrazu";
				}
				
				
				if ($row[1] eq $w1)
				{
					$dbh->do("DELETE FROM synonimy WHERE id=$row[0]");
				}
				
				$sth->finish;
				$dbh->disconnect();
			}else
			{
				print "Nie podałeś wyrazu";
			}
		}
	}
}
print end_html;
