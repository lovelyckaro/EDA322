report:
	@echo "Compiling pdf..."
	@latexmk -pdf report.tex

zip: report
	mkdir -p Report-and-code-Love-Lyckaro-William-Risne 
	cp *.vhd Report-and-code-Love-Lyckaro-William-Risne/
	cp *.do Report-and-code-Love-Lyckaro-William-Risne/
	cp report.pdf Report-and-code-Love-Lyckaro-William-Risne/
	zip -r Report-and-code-Love-Lyckaro-William-Risne.zip Report-and-code-Love-Lyckaro-William-Risne/*
	rm -rf Report-and-code-Love-Lyckaro-William-Risne
