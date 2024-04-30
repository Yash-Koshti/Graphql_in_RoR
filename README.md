# README

This is a Blog app which has Users, Blogs and Comments. <br>
It is made using Ruby on Rails and Postgresql as database. <br>
This app has been made using the Graphql.

It has some seed to start with and also has CRUD operations avaiable on all its models.

It also has dynamic queries for Blog and Comment, such as

```
blogs{
    id
    title
    content
    user{
        id
        userName
        email
    }
}

blogs(userId: 1){
    id
    title
    content
    user{
        id
        userName
        email
    }
}
```

## Ruby version

- ruby-3.0.0

## System dependencies

1. Graphql ~> 2.3

## Configuration

- It has graphiql installed so you can test the graphql queries using /graphiql route.

## Database creation & initialization

```
rails db:create db:migrate db:seed
```
