# Sudoku-helper-solver Infra-as-Code

Maintain infrastructure as code for the sudoku app which consists of frintend and backend code bases.

## Code bases

- [Sudoku Backend](https://github.com/DoctorrDeep/sudoku-helper-solver-backend)
- [Sudoku Frontend](https://github.com/DoctorrDeep/sudoku-helper-solver-frontend)

## Setup

To run the terraform code you need to set the following up
- `token`: linode token, type: string
- `ssh_key`: type: string
- `root_pass`: root password needed to ssh into machine, type: string
- `sudoku_be_repo`: location of BE repo on the machine executing terraform/make commands of this repo
- `sudoku_fe_repo`: location of FE repo on the machine executing terraform/make commands of this repo
- `sudoku_cert_loc`: location of certificate files folder (2 files, 1 folder) on the machine executing terraform/make commands of this repo. The files are described below.
  - `ambardas.nl.pem` file
  - `ambardas.nl.key` file
