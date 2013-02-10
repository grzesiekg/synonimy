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
			-values=>['szukaj', 'dodaj','usuń','popraw']),p,
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
					binmode STDOUT, ":encoding(utf8)";
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
		case "usuń" {
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
				$id=$row[0];
				if ($sth->rows == 0)
				{
					print "Nie znaleziono wyrazu";
				}
				
#jeżeli jest tylko jeden wyraz w wierszu kasujemy cały wiersz				
				elsif (!$row[2])
				{
					$dbh->do("DELETE FROM synonimy WHERE id=$id");
					print "Wyraz: $w1 usunięty";
				}
#jeżeli ostatni wyraz w wierszu jest szukanym to wstawiamy tam nulla				
				elsif ($row[3] eq $w1)
				{
					$dbh->do("UPDATE synonimy SET wyraz3=NULL WHERE id=$id");
					print "Wyraz: $w1 usunięty";
				}
#jeżeli grupa ma tylko 2 wyrazy to kasujemy szukany i w razie konieczności kasujemy wyraz1 i wstawiamy na jego miejsce wyraz2			
				elsif (!$row[3])
				{
					if ($row[2] eq $w1)
					{
						$dbh->do("UPDATE synonimy SET wyraz2=NULL WHERE id=$id");
						print "Wyraz: $w1 usunięty";
					}else
					{
						$dbh->do("UPDATE synonimy SET wyraz1='$row[2]', wyraz2=NULL WHERE id=$id");
						print "Wyraz: $w1 usunięty";
					}
				}
#to samo co wyżej tylko dla grupy 3 wyrazów				
				else
				{
					if ($row[2] eq $w1)
					{
						$dbh->do("UPDATE synonimy SET wyraz2='$row[3]', wyraz3=NULL WHERE id=$id");
						print "Wyraz: $w1 usunięty";
					}else
					{
						$dbh->do("UPDATE synonimy SET wyraz1='$row[3]', wyraz3=NULL WHERE id=$id");
						print "Wyraz: $w1 usunięty";
					}
				}
				
				
				$sth->finish;
				$dbh->disconnect();
			}else
			{
				print "Nie podałeś wyrazu";
			}
		}
		
		case "popraw"{
			if ($w1 && $w2)
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
				$id=$row[0];
				if ($sth->rows == 0)
				{
					print "Nie znaleziono wyrazu";
				}
#podstawiamy wyraz2 za wyraz1 w bazie				
				else
				{
					if ($row[1] eq $w1)
					{
						$dbh->do("UPDATE synonimy SET wyraz1='$w2' WHERE id=$id");
					}elsif ($row[2] eq $w1)
					{
						$dbh->do("UPDATE synonimy SET wyraz2='$w2' WHERE id=$id");
					}else
					{
						$dbh->do("UPDATE synonimy SET wyraz3='$w2' WHERE id=$id");
					}
					
					print "Wyraz: $w1 poprawiony na: $w2";
				}
				
				$sth->finish;
				$dbh->disconnect();
			}else
			{
				print "Nie podałeś wyrazów";
			}
		}
	}
}
print end_html;
