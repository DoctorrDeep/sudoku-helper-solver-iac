# Sudoku-helper-solver Infra-as-Code

Maintain infrastructure as code for the sudoku app which consists of frintend and backend code bases.

## Code bases

- [Sudoku Backend](https://github.com/DoctorrDeep/sudoku-helper-solver-backend)
- [Sudoku Frontend](https://github.com/DoctorrDeep/sudoku-helper-solver-frontend)

## Setup

To run the terraform code you need to set the following up in __terraform.tfvars__ in the root of this repository.
- `token = ""`: linode token, type: string
- `ssh_key = ""`: ssh_key of the local machine type: string
- `root_pass = ""`: root password needed to ssh into machine, type: string
- `be_tag = "vX.Y"`: Tag of docker backend image needed from  [ambardeepdas/sudoku-solver-python-backend](https://hub.docker.com/r/ambardeepdas/sudoku-solver-python-backend/tags)
- `fe_tag = "vX.Y"`: Tag of docker frontend image needed from  [ambardeepdas/sudoku-solver-react-frontend](https://hub.docker.com/r/ambardeepdas/sudoku-solver-react-frontend/tags)
- `sudoku_cert_loc = ""`: location of certificate files folder named __certs__ (2 files, 1 folder) on the machine executing terraform/make commands of this repo. The files are described below. No trailing slashes in the string. It should end in `..../certs`
  - `ambardas.nl.pem` file with RapidSSL pem file contents and personal pem file data
  - `ambardas.nl.key` file
  - Name the folder `certs`

## Deploy

Follow the calls listed in the __Makefile__

## TODO

- Add RapidSSL pem file contents and personal pem file data into 1 file to be uploaded or mention 2 pem filed in nginx
