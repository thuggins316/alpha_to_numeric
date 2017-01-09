#!/usr/bin/perl

use strict;			#enforce good programming rules
use Getopt::Std;	#module that allow for command line options

#reading options
our ($opt_i); 		#'our' declares package variables
getopts('i:'); 		#create and process a single-character switch where 'i' is a boolean flag. The ":" expects something to come after the flag
if (!$opt_i) { 		
    print STDERR "\nInput file name (-i) required\n\n\n";		#states input file required if not loaded
}

#open the file or die
open INFILE, "<", $opt_i or die "No such input file $opt_i";

my $first_line = 1; 	#used to skip the header;

#reads the file line by line
while (<INFILE>) {

    # the variable $_ contains the current line.
    chomp $_; 		#strips the new line character from the current input

    #skips the header
    if ($first_line) { 
	
	#print the header to the output
	print "$_\n";
	$first_line = 0;
	next;			#starts the next iteration of the loop
    }

    #turns the current tab delimited line into an array of values
	#splits string into a list on tab
    my @row =  split('\t', $_);

    ###################################
    #here is where we actually process the row
    #the objective in this case is to get alleles identified for each markers
    ###################################

    #read and removes the first four "cell" of the row
	#shifts each cell thus shortening array by 1 and moving everything down
    my $marker_name = shift @row;	#shifts first value(marker name) of array off and return it
    my $allele_bases = shift @row; 	#shift the second value(allele for cureent marker) of array
    my $chromosome = shift @row; 	#shift the third value(chromosome) of array
    my $positions = shift @row;		#shift the fourth value(position) of array
    
   	
	#array of marker nucleotides for each individual
	#after removing first four cells, remaining cells are stored in an array
    my @all_alleles = @row; 
	#print Dumper(@all_alleles); #allow the contents of array to be viewed
	
    #split each $allele_bases(A/G) string by slash
	#the result(AG) is stored in an array
   	my @split_cell = split('\/', $allele_bases);
	
	#print contents of array to screen
	#print  STDERR $split_cell[0] . $split_cell[1]."\t";

	#assign first and second elements of array to scalar variable
	my $allele1 = @split_cell[0];	#stores the first element of array into a string
	my $allele2 = @split_cell[1];	#stores the second element of array into a string
	
	print "$marker_name\t";		#print marker name to file
	print "$allele_bases\t";	#print original allele to file
	print "$chromosome\t";		#print chromosome number to file
	print "$positions\t";		#print marker position to file
	
	#for each row, match pattern on right in @all_alleles array on left and replace within row
	foreach my $marker (@all_alleles) {
		$marker =~ s/($allele1)/1/g;	#in @all_alleles match pattern/$allele1/ and replace with 1 if found 
		$marker =~ s/($allele2)/-1/g;	#in @all_alleles match pattern/$allele2/ and replace with -1 if found
		$marker =~ s/[RYSWKM]/0/g;		#in @all_alleles match any one of the strings in pattern/[RYSWKM]/ and replace with 0 if found
		$marker =~ s/N/NA/g;			#in @all_alleles match pattern/N/ and replace with NA if found
	print "$marker \t";					#print the string $marker with tab as delimiter 
    }
    

	
    #go cell by cell through the line to reprint
	#after match and replace, print each new row of array @all_alleles
    foreach my $marker (@all_alleles) {

	print "\t"; #tab delimited

	}
    print "\n"; #ends the line
}

close INFILE; #close file
