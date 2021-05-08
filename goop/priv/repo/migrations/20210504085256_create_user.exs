defmodule Rath.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";","")
      create table(:users, primary_key: false) do
        add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
        add :google_id, :string, null: false
        add :google_access_token, :text, null: false
        add :google_refresh_token, :text, null: false
        add :token_version, :integer, null: false
        add :name, :text, null: false
        add :email, :text, null: false
        add :avatar_url, :text, null: false

        timestamps()
      end

      create unique_index(:users, [:google_id])
      create unique_index(:users, [:email])

      create table(:roles, primary_key: false) do
        add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
        add :name, :string, null: false

        timestamps()
      end

      create table(:user_address, primary_key: false) do
        add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
        add :address_line_1, :text, null: false
        add :address_line_2, :text, null: false
        add :district, :text, null: false
        add :post_code, :string, null: false
        add :telephone, :string, null: true
        add :mobile, :string, null: false

        add :user_id, references(:users, type: :uuid, on_delete: :nilify_all)

        timestamps()
      end

      alter table(:users) do
        add :role_id, references(:roles, type: :uuid, on_delete: :nilify_all)
        add :address_id, references(:user_address, type: :uuid, on_delete: :nilify_all)
      end

      create unique_index(:users, [:address_id])
  end
end
