export PATH=$PATH:$HOME/.local/bin

echo "Performing a local install of incarcero in development mode"
pip3 install -e .

echo "Fetching all templates..."
TEMPLATES=$(incarcero list | head -n-1 | tail -n+3; exit ${PIPESTATUS[0]})
if [[ $? != 0 ]]; then
        echo "incarcero didn't list templates. This is a fatal error. Force failing the build."
	exit 1
fi


# build all templates
declare -A RESULTS
WORST_EXIT_STATUS=0
for _T in $TEMPLATES; do
        echo "Building template $_T"
        incarcero --config tests/smoke/config.js build --force --skip-vagrant-box-add $_T
	EXIT_VAL=$?
	if (( $EXIT_VAL > $WORST_EXIT_STATUS )); then
		WORST_EXIT_STATUS=$EXIT_VAL
	fi
        RESULTS[$_T]=$EXIT_VAL
done

echo Finished building all templates. Results:
for _T in "${!RESULTS[@]}"; do
  echo "$_T: ${RESULTS[$_T]}"
done

# Not necessarily worse but at least non-zero
exit $WORST_EXIT_STATUS
