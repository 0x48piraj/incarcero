test:
	pylint incarcero
	./tests/config_example_valid.sh
	python3 -m unittest discover

pylint:
	pylint incarcero --rcfile=override

pkg_clean:
	rm -r build/ dist/ incarcero.egg-info/
