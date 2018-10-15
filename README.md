# Provision and deployment Node apps

O projeto consiste em provisionamento de máquinas automatizado e deploy blue/green para aplicações nodes 
Servidores para a aplicação e servidor de load balancer com (haproxy)[http://www.haproxy.org/].

E alguns scripts para teste de carga e parseamento de logs.

### Warning
Este é apenas um exemplo simples, poderia ter usado o sistema de cluster provido pelo node, mas como é exemplo utilizamos para cada CPU disponível na máquina um novo processo da aplicação em uma porta diferente.

## Requirements 
- (Ansible)[https://www.ansible.com/]
- (Capistrano)[https://capistranorb.com/] `gem install capistrano`
    - Capistrano npm (`gem install capistrano-npm`)
- (Vagrant)[https://www.vagrantup.com/] (Apenas para testes locais)


## Provision
Para provisionar os servidores basta configurar o arquivo `ansible/hosts` com os domínios/ips,  
para o propósito de testes locais a pasta `local/servers` contém Vagrants files para app e load balancer.


### Command ansible
Primeiro baixamos as dependecias que são
- geerlingguy.certbot para certificados ssl
- hashbangcode.sendmail para envio de email simples

command: `cd ansible && ansible-galaxy install -r requirements.yml`     
Agora basta aplicar os playbooks    
command: `ansible-playbook playbooks/site.yml`

## Deploy 
Para o deploy utilizamos o Capistrano, uma ferramente extremamente flexível para deploys e robusta.     
A configuração de servidores deve ser feita em `config/deploy/production.rb` e `config/deploy/staging.rb` e a configuração do repositório git deve ser feita no arquivo `config/deploy.rb`

### Command capistrano
command: `cap production deploy`

A partir deste momento já deve estar acessivel pelo domínio/ip do servidor de load balancer (192.168.33.29 local) na porta 80.

Há um cron configurado para rodar o teste de carga usando Apache Benchmark todos os dias as 3:00AM parseamento de logs e envio por email.



## Concluding Remarks
Para o funcionamento de https é necessário um domínio válido para o certboot funcionar, e deve adicionar a variável `cerboot: true` dentro do  arquivo `ansible/group_vars/lb/bootstrap.yml`.   

Com o avanço de tecnologias como (docker)[https://www.docker.com/] e (kubernetes)[https://kubernetes.io/] é muito mais viável utilizar destas.   
Com containers é possível isolar toda a aplicação e deixar disponível o mesmo envirorment para todos, devs, qas, staging e production.  
E com kubernetes todo o gerenciamento de carga, auto scaling e monitoramento é muito mais simples, além de contar com o (helm)[https://helm.sh/] para facilitar o processo de deployment.
