require 5.000;
use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'         => 'Template::Plugin::Cycle',
	'VERSION_FROM' => 'lib/Template/Plugin/Cycle.pm',
	'PREREQ_PM'    => {
		# Test dependencies
		File::Spec => '0.82',
		Test::More => 0,
	},
	($] >= 5.005) ? (
		'AUTHOR'   => 'Adam Kennedy (cpan@ali.as)',
		'ABSTRACT' => 'A heavily DWIM module to cycle through a set of values',
	) : (),
);
