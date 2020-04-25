import azure.cosmos.cosmos_client as cosmos_client
import azure.cosmos.documents as documents
from azure.cosmos import errors, http_constants
import family
import json


endpoint = 'https://dp200cdb.documents.azure.com:443/'
key = 'XXXX'

client = cosmos_client.CosmosClient(endpoint, {'masterKey': key})

database_name = 'AzureSampleFamilyDatabase'

try:
    database = client.CreateDatabase(database={'id':database_name})
except errors.HTTPFailure:
    database = client.ReadDatabase("dbs/" + database_name)


container_name = 'FamilyContainer'

container_definition = {'id': 'family',
                        'partitionKey':
                                    {
                                        'paths': ['/lastName'],
                                        'kind': documents.PartitionKind.Hash
                                    }
                        }

try:
    container = client.CreateContainer("dbs/" + database['id'], container_definition, {'offerThroughput': 400})
except errors.HTTPFailure as e:
    if e.status_code == http_constants.StatusCodes.CONFLICT:
        container = client.ReadContainer("dbs/" + database['id'] + "/colls/" + container_definition['id'])
    else:
        raise e


family_items_to_create = [family.get_andersen_family_item(),
                          family.get_johnson_family_item(),
                          family.get_smith_family_item(),
                          family.get_wakefield_family_item()]

for family_item in family_items_to_create:
    client.UpsertItem("dbs/" + database['id'] + "/colls/" + container_definition['id'],
              document=family_item)

with open('./database/example_query.sql', 'r') as query_file:
    query_example = query_file.read()

for item in client.QueryItems("dbs/" + database['id'] + "/colls/" + container_definition['id'],
                              query_example,
                              {'enableCrossPartitionQuery': True}):
    print(json.dumps(item, indent=True))