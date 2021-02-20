# pipeline_aia
Is a part of [Coronal Jets Analyser package](https://github.com/coronal-jets).

Downloads AIA/data from JSOC, find jet-like occurencies and prepares a movie.

## Dependencies
* Some routines are required [Solar Soft](https://www.lmsal.com/solarsoft/ssw_packages_info.html) environment installed.
* Requires [common utilites](https://github.com/coronal-jets/pipeline_common).

## Update History
* 19 February 2021: major revision, including:
	* some bugfixing, polishing, and refactoring;
	* AS or SA methods can be chosen for comarison and test purpuses;
	* two types of graphics output (direct graphics for faster output);
	* more detailed report;
	* additional optional parameters introduced:
		* source sizes and wavelength list;
		* maximum time of event (to avoid typos in config);
		* details of visualization (type of jet representation, png/jpeg key);
	* batch mode implemented, to provide batch execution of config's set.
* 20 February 2021: polishing, console reports improved, including times

