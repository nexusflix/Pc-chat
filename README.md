# ThyoCloud Win11 Persistent

Projeto base para executar uma VM Windows 11 via QEMU em um runner Linux e
restaurar/salvar o disco virtual entre sessões.

## Importante

Este projeto NÃO inclui uma ISO do Windows. Use uma ISO oficial/licenciada do
Windows 11 que você tenha direito de usar.

O GitHub-hosted runner é temporário. Para persistência real de uma VM completa,
é necessário um armazenamento externo com espaço suficiente para o VHDX/QCOW2.
GitHub Actions artifacts/cache não são adequados para um disco completo do
Windows 11.

## Credenciais padrão

Usuário: `DANIEL`
Senha: `DANIEL`

A senha aparece no workflow apenas como configuração de exemplo. Troque-a antes
de usar em um ambiente público.

## Estrutura

- `.github/workflows/windows11.yml` — fluxo principal
- `scripts/prepare.sh` — instala QEMU e cria a VM
- `scripts/create-answer.ps1` — exemplo de configuração automática do Windows
- `scripts/save.sh` — compacta o disco
- `scripts/restore.sh` — restaura o disco
- `scripts/README.md` — detalhes dos scripts

## Limitação importante

O GitHub Actions não fornece uma VM Windows 11 persistente nem garante
virtualização aninhada/KVM para uma VM Windows. Se QEMU precisar usar TCG,
o Windows poderá ficar muito lento. Para desempenho de PC real, o mesmo projeto
deve ser executado em um servidor/VPS com KVM.

## Próximo passo

1. Crie um repositório privado.
2. Adicione os arquivos deste ZIP.
3. Escolha onde ficará o disco persistente.
4. Configure os segredos necessários no GitHub.
5. Coloque uma ISO oficial do Windows 11 em um armazenamento que você controla.
6. Aponte `WIN_ISO_URL` para ela ou adapte o workflow para o seu armazenamento.

Não coloque a ISO dentro do repositório.
