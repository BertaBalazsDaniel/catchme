using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;

namespace UnitTestProject
{
    class FakeDbSet<T> : DbSet<T>, IQueryable<T>, IEnumerable<T> where T : class
    {
        private readonly List<T> _items;

        public FakeDbSet(IEnumerable<T> items = null)
        {
            _items = items?.ToList() ?? new List<T>();
        }

        public override T Add(T item)
        {
            _items.Add(item);
            return item;
        }

        public override T Remove(T item)
        {
            _items.Remove(item);
            return item;
        }

        public override IEnumerable<T> AddRange(IEnumerable<T> entities)
        {
            _items.AddRange(entities);
            return entities;
        }

        public override IEnumerable<T> RemoveRange(IEnumerable<T> entities)
        {
            foreach (var e in entities)
                _items.Remove(e);
            return entities;
        }

        public override T Attach(T item)
        {
            _items.Add(item);
            return item;
        }

        public override T Create()
        {
            return Activator.CreateInstance<T>();
        }

        public IEnumerator<T> GetEnumerator()
        {
            return _items.GetEnumerator();
        }


        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        public Type ElementType => typeof(T);
        public Expression Expression => _items.AsQueryable().Expression;
        public IQueryProvider Provider => _items.AsQueryable().Provider;
    }
}