# Ansible Nginx Role

[![Build Status](https://travis-ci.org/weareinteractive/ansible-nginx.png?branch=master)](https://travis-ci.org/weareinteractive/ansible-nginx)
[![Stories in Ready](https://badge.waffle.io/weareinteractive/ansible-nginx.svg?label=ready&title=Ready)](http://waffle.io/weareinteractive/ansible-nginx)

> `nginx` is an [ansible](http://www.ansible.com) role which: 
> 
> * installs nginx
> * configures nginx
> * creates sites
> * enables/disables sites
> * optionally removes default host
> * adds rules
> * configures service

## Installation

Using `ansible-galaxy`:

```
$ ansible-galaxy install franklinkim.nginx
```

Using `arm` ([Ansible Role Manager](https://github.com/mirskytech/ansible-role-manager/)):

```
$ arm install franklinkim.nginx
```

Using `git`:

```
$ git clone https://github.com/weareinteractive/ansible-nginx.git
```

## Dependencies

* [franklinkim.openssl](https://github.com/weareinteractive/ansible-openssl)
* [franklinkim.htpasswd](https://github.com/weareinteractive/ansible-htpasswd)

## Variables

Here is a list of all the default variables for this role, which are also available in `defaults/main.yml`.

```
# run as a less privileged user for security reasons.
nginx_user: www-data
# auto or a number
nginx_worker_processes: auto
nginx_worker_connections: 768
# default settings
nginx_sendfile: 'on'
nginx_tcp_nopush: 'on'
nginx_tcp_nodelay: 'on'
nginx_keepalive_timeout: 54
nginx_types_hash_max_size: 2048
nginx_server_tokens: 'off'
# remove default site
nginx_remove_default: no
# start on boot
nginx_service_enabled: yes
# current state: started, stopped
nginx_service_state: started
# enabled/disabled sites
nginx_sites: []
```

A site might be defined through:

```
# site id (required)
id: foo
# server name (required)
name: foo.com
# ip to listen to
ip: '*'
# port to listen to
port: 80
# state: present | absent
state: present
# create the /var/www/[id]/htdocs folder
add_webroot: no
# path to your own site template
template: path/to/template.j2
# /etc/nginx/rules/[rule].conf to include
rules: []
# list of server aliases
aliases: []
# list of server redirects
redirects: []
# enable ssl
ssl:
  # port to listen to
  port: 443
  # @see franklinkim.openssl
  key_name: mykey
  cert_name: mycert
# enable auth
auth:
  # @see franklinkim.htpasswd
  name: foo
  file: foo
# custom string to append to the site
append: false
```

## Handlers

These are the handlers that are defined in `handlers/main.yml`.

* `restart nginx` 

## Rules

In addition there will be copied some configuration rules to `/etc/nginx/rules`:

* cache_busting.conf  
* cors_web_fonts.conf 
* gzip.conf           
* no_transform.conf   
* ssl.conf
* cors_ajax.con       
* expires.conf        
* gzip_static.conf    
* security.conf

These can be included into your site definitions.

## Example playbook

```
- hosts: all
  roles: 
    - franklinkim.nginx
  vars:
    nginx_worker_processes: 1
    nginx_remove_default: yes
    htpasswd:
      - name: foobar
        users:
          - { name: foobar, password: foobar }
    openssl_self_signed:
      - { name: 'foobar.local', country: 'DE', state: 'Bavaria', city: 'Munich', organization: 'Foo Bar', email: 'foo@bar.com' }
    nginx_sites:
      - id: foobar
        add_webroot: yes
        name: foobar.local
        ssl:
          key_name: foobar.local
          cert_name: foobar.local
        rules:
          - gzip
          - security
        auth:
          name: Foo Bar
          file: foobar
```

## Notes

You can use `franklinkim.apt` to add a repository to get the latest `nginx`:

```
apt_repositories:
  - 'ppa:nginx/stable'
```

## Testing

```
$ git clone https://github.com/weareinteractive/ansible-nginx.git
$ cd ansible-nginx
$ vagrant up
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests and examples for any new or changed functionality.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
Copyright (c) We Are Interactive under the MIT license.
