from codec import Codec
import cbor


class ISRC(Codec):
    thing_location = 'loc'

    def decode(self, data):
        print("Hello")
        d = cbor.loads(data)

        if 'lat' in d and 'lng' in d:
            d['loc'] = self.create_location(d['lat'], d['lng'])
            del d['lat']
            del d['lng']

        return d

    def encode(self, data):
        return cbor.dumps(data)
