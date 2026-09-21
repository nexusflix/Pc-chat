# Scripts

`prepare.sh`
Instala QEMU e cria diretórios.

`restore.sh`
Restaura `state/windows11-latest.qcow2`, quando esse arquivo existir.

`run-vm.sh`
Inicia a VM. A primeira inicialização usa a ISO; depois pode iniciar pelo
disco.

`save.sh`
Cria uma cópia compactada do disco.

`create-answer.ps1`
É um ponto de partida para automatizar a instalação/configuração do Windows.

## Persistência

Este pacote ainda não escolhe um provedor externo de armazenamento porque o
disco completo do Windows pode ter dezenas de GB. Para uma solução realmente
persistente, conecte um backend como armazenamento S3-compatible, Google Drive,
OneDrive ou um servidor próprio e faça upload/download do `windows11.qcow2`.

O workflow propositalmente não tenta usar GitHub cache/artifact como disco
permanente.
