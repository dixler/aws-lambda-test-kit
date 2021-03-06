test: .terraform terraform.tfstate test.json
	aws lambda invoke --function-name "$$(terraform output lambda-target)" --log-type 'Tail' --payload "$$(cat test.json)" outfile.log > output.log
	@echo ------------------------------------------------------------------
	@echo Return value:
	@echo ------------------------------------------------------------------
	@cat ./outfile.log
	@echo
	@echo
	@echo
	@echo
	@echo ------------------------------------------------------------------
	@echo Output:
	@echo ------------------------------------------------------------------
	@cat ./output.log | grep '"LogResult":' | awk '{ print $$2 }' | sed 's/"//g' | sed 's/,//g' | base64 -d
	@echo
	@rm ./outfile.log ./output.log
.terraform: Readme.md
	terraform init
terraform.tfstate: main.tf source/lambda_handler.py
	cd source/; zip lambda_function_payload.zip ./ -r; mv lambda_function_payload.zip ../
	echo yes | terraform apply
	rm -rf *.zip
clean:
	cd source/; zip lambda_function_payload.zip ./ -r; mv lambda_function_payload.zip ../
	echo yes | terraform destroy
	rm -rf *.zip *.tfstate*
