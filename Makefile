.DEFAULT_GOAL := zip
report:
	@printf "\u001b[34mCompiling pdf...\u001b[0m\n"
	@latexmk -pdf report.tex

zip: report
	@printf "\u001b[34mMaking temporary directory...\u001b[0m\n"
	@mkdir -p Report-and-code-Love-Lyckaro-William-Risne 
	@printf "\u001b[34mCopying everything into directory...\u001b[0m\n"
	@cp *.vhd Report-and-code-Love-Lyckaro-William-Risne/
	@cp *.do Report-and-code-Love-Lyckaro-William-Risne/
	@cp report.pdf Report-and-code-Love-Lyckaro-William-Risne/
	@printf "\u001b[34mzipping directory...\u001b[0m\n"
	@zip -r Report-and-code-Love-Lyckaro-William-Risne.zip Report-and-code-Love-Lyckaro-William-Risne/*
	@printf "\u001b[34mRemoving temporary directory...\u001b[0m\n"
	@rm -rf Report-and-code-Love-Lyckaro-William-Risne
	@printf "\u001b[32;1mDone!\u001b[0m\n"
